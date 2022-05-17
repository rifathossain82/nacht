import 'dart:convert';

import 'package:chapturn_sources/chapturn_sources.dart' as sources;
import 'package:dartz/dartz.dart';
import 'package:drift/drift.dart';

import '../../../core/core.dart';
import '../../../domain/domain.dart';
import '../../data.dart';
import '../../failure.dart';
import '../../misc/into_companion.dart';

class NovelRepositoryImpl with LoggerMixin implements NovelRepository {
  NovelRepositoryImpl({
    required this.database,
  });

  final AppDatabase database;

  @override
  Future<Either<Failure, NovelData>> getNovel(int id) async {
    final query = database.select(database.novels).join([
      leftOuterJoin(
        database.assets,
        database.assets.id.equalsExp(database.novels.coverId),
      ),
    ])
      ..where(database.novels.id.equals(id));

    return await _getNovel(query);
  }

  @override
  Future<Either<Failure, NovelData>> getNovelByUrl(String url) async {
    final query = database.select(database.novels).join([
      leftOuterJoin(
        database.assets,
        database.assets.id.equalsExp(database.novels.coverId),
      ),
    ])
      ..where(database.novels.url.equals(url));

    return await _getNovel(query);
  }

  Future<Either<Failure, NovelData>> _getNovel(
    JoinedSelectStatement<HasResultSet, dynamic> query,
  ) async {
    final result = await query.getSingleOrNull();
    if (result == null) {
      return const Left(NovelNotFound());
    }

    final novel = result.readTable(database.novels);
    final asset = result.readTableOrNull(database.assets);

    final metadata = (await getMetaData(novel.id))
        .map((value) => MetaEntryData.fromModel(value))
        .toList();
    final volumes = await _getVolumesOfNovel(novel.id);

    final entity = NovelData.fromModel(novel).copyWith(
      volumes: volumes,
      metadata: metadata,
      cover: asset == null ? null : AssetData.fromModel(asset),
    );

    return Right(entity);
  }

  Future<List<VolumeData>> _getVolumesOfNovel(
    int novelId,
  ) async {
    final query = database.select(database.volumes)
      ..where((tbl) => tbl.novelId.equals(novelId));
    final volumes = await query.get();

    final entities = <VolumeData>[];
    for (final volume in volumes) {
      final entity = VolumeData.fromModel(volume)
          .copyWith(chapters: await _getChapterModelsOfVolume(volume.id));
      entities.add(entity);
    }

    return entities;
  }

  Future<List<ChapterData>> _getChapterModelsOfVolume(
    int volumeId,
  ) async {
    return (await _getChaptersOfVolume(volumeId))
        .map(ChapterData.fromModel)
        .toList();
  }

  Future<List<Chapter>> _getChaptersOfVolume(int volumeId) async {
    final query = database.select(database.chapters)
      ..where((tbl) => tbl.volumeId.equals(volumeId));
    return await query.get();
  }

  @override
  Future<Either<Failure, UpdateResult>> updateNovel(sources.Novel novel) async {
    log.fine('starting novel update');

    final novelCompanion = novelIntoCompanion(novel);

    UpdateResult result = UpdateResult(initial: true, novel: -1, inserted: []);

    await database.transaction(() async {
      // Upsert the novel entity itself
      final currentNovel = await (database.select(database.novels)
            ..where((tbl) => tbl.url.equals(novelCompanion.url.value)))
          .getSingleOrNull();

      result = result.copyWith(initial: currentNovel == null);
      if (result.initial) {
        final id = await database.into(database.novels).insert(novelCompanion);

        result = result.copyWith(novel: id);
      } else {
        await (database.update(database.novels)
              ..where((tbl) => tbl.id.equals(currentNovel!.id)))
            .replace(novelCompanion);

        result = result.copyWith(novel: currentNovel!.id);
      }

      final novelModel = await database.into(database.novels).insertReturning(
            novelCompanion,
            onConflict: DoUpdate(
              (old) => novelCompanion,
              target: [database.novels.url],
            ),
          );

      // Update volumes and chapters (editing, removing)
      final inserts = await syncVolumes(novelModel.id, novel.volumes);

      // Insert chapters.
      log.fine('inserting chapters');
      final insertedIds = <int>[];
      for (final companion in inserts) {
        final id = await database.into(database.chapters).insert(companion);
        insertedIds.add(id);
      }

      result = result.copyWith(inserted: insertedIds);

      // Update metadata.
      await syncMetaData(novelModel.id, novel.metadata);
    });

    // FIXME: handle where transaction failed

    log.fine('ending novel update');

    return Right(result);
  }

  Future<List<ChaptersCompanion>> syncVolumes(
    int novelId,
    List<sources.Volume> volumes,
  ) async {
    final insertCompanions = <ChaptersCompanion>[];

    log.fine('syncing volumes');
    final volumeModels = <Volume, List<sources.Chapter>>{};
    for (final volume in volumes) {
      final volumeCompanion =
          volumeIntoCompanion(volume).copyWith(novelId: Value(novelId));

      final model =
          await database.into(database.volumes).insertReturning(volumeCompanion,
              onConflict: DoUpdate(
                (old) => volumeCompanion,
                target: [
                  database.volumes.novelId,
                  database.volumes.volumeIndex
                ],
              ));

      volumeModels[model] = volume.chapters;
    }

    log.fine('updating and removing chapters');
    await database.batch((batch) async {
      for (final entry in volumeModels.entries) {
        final volume = entry.key;
        final chapters = entry.value;

        final diff = calculateDiff<Chapter, sources.Chapter>(
          prev: IdentityList<Chapter, String>(
            items: await _getChaptersOfVolume(volume.id),
            identity: (item) => item.url,
          ),
          next: IdentityList<sources.Chapter, String>(
            items: chapters,
            identity: (item) => item.url,
          ),
          equality: (prev, next) {
            return prev.title == next.title &&
                prev.updated == next.updated &&
                prev.chapterIndex == next.index;
          },
        );

        for (final change in diff) {
          change.map(
            insert: (state) async {
              final chapterCompanion = chapterIntoCompanion(state.data)
                  .copyWith(volumeId: Value(volume.id));

              insertCompanions.add(chapterCompanion);
              log.finer(
                  'insert chapter ${state.data.index} ${state.data.title}');
            },
            remove: (state) {
              batch.delete(database.chapters, state.data);
              log.finer(
                  'remove chapter ${state.data.chapterIndex} ${state.data.title}');
            },
            replace: (state) {
              final chapterCompanion =
                  chapterIntoCompanion(state.next).copyWith(
                id: Value(state.prev.id),
                volumeId: Value(volume.id),
                content: const Value.absent(),
              );

              batch.replace(database.chapters, chapterCompanion);
              log.finer(
                  'replace chapter ${state.next.index} ${state.next.title}');
            },
            keep: (state) {
              log.finer('keep chapter ${state.next.index} ${state.next.title}');
            },
          );
        }
      }
    });

    return insertCompanions;
  }

  // MetaData.

  Future<List<MetaEntry>> getMetaData(int novelId) async {
    final query = database.select(database.metaEntries)
      ..where((tbl) => tbl.novelId.equals(novelId));

    return await query.get();
  }

  Future<void> syncMetaData(
    int novelId,
    List<sources.MetaData> metaData,
  ) async {
    log.info('syncing metadata.');

    final diff = calculateDiff<MetaEntry, sources.MetaData>(
      prev: IdentityList<MetaEntry, Tuple2>(
        items: await getMetaData(novelId),
        identity: (item) => Tuple2(item.name, item.value),
      ),
      next: IdentityList<sources.MetaData, Tuple2>(
        items: metaData,
        identity: (item) => Tuple2(item.name, item.value),
      ),
      equality: (prev, next) =>
          (prev.others == null
              ? null
              : Map<String, Object>.from(json.decode(prev.others!))) ==
          next.others,
    );

    await database.batch((batch) {
      for (final change in diff) {
        change.map(
          insert: (state) {
            final companion = metaDataIntoCompanion(state.data)
                .copyWith(novelId: Value(novelId));

            batch.insert(database.metaEntries, companion);
            log.finer(
                'insert meta entry ${state.data.name}: ${state.data.value}');
          },
          remove: (state) {
            batch.delete(database.metaEntries, state.data);
            log.finer(
                'remove meta entry ${state.data.name}: ${state.data.value}');
          },
          replace: (state) {
            final companion = metaDataIntoCompanion(state.next).copyWith(
              id: Value(state.prev.id),
              novelId: Value(novelId),
            );

            batch.replace(database.metaEntries, companion);
            log.finer(
                'replace meta entry ${state.next.name}: ${state.next.value}');
          },
          keep: (state) {
            log.finer(
                'keep meta entry ${state.next.name}: ${state.next.value}');
          },
        );
      }
    });
  }

  // Single field updates.

  @override
  Future<void> setFavourite(int novelId, bool value) async {
    final companion = NovelsCompanion(
      id: Value(novelId),
      favourite: Value(value),
    );

    await _update(companion);
  }

  @override
  Future<void> setCover(int novelId, AssetData asset) async {
    final companion = NovelsCompanion(
      id: Value(novelId),
      coverId: Value(asset.id),
    );

    await _update(companion);
  }

  Future<void> _update(NovelsCompanion companion) async {
    final statement = database.update(database.novels)
      ..whereSamePrimaryKey(companion);

    await statement.write(companion);
  }
}