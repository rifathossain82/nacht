import 'package:chapturn/data/datasources/local/database.dart';
import 'package:chapturn/data/mappers/mappers.dart';
import 'package:chapturn/data/mappers/network/connection_mapper.dart';
import 'package:chapturn/data/mappers/sources/partial_novel_source_mapper.dart';
import 'package:chapturn/domain/entities/novel/novel_entity.dart';
import 'package:chapturn/domain/mapper.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:chapturn_sources/chapturn_sources.dart' as sources;

final partialNovelSourceFromMapper =
    Provider<SourceToPartialNovelMapper>((ref) => SourceToPartialNovelMapper());

final connectivityToConnectionMapper = Provider<ConnectivityToConnectionMapper>(
    ((ref) => ConnectivityToConnectionMapper()));

// To seeds.

final novelStatusToSeedMapper = Provider<Mapper<sources.NovelStatus, int>>(
    (ref) => NovelStatusToSeedMapper());

final workTypeToSeedMapper =
    Provider<Mapper<sources.WorkType, int>>((ref) => WorkTypeToSeedMapper());

final readingDirectionToSeedMapper =
    Provider<Mapper<sources.ReadingDirection, int>>(
        (ref) => ReadingDirectionToSeedMapper());

// From seeds.

final seedToNovelStatusMapper = Provider<Mapper<int, sources.NovelStatus>>(
    (ref) => SeedToNovelStatusMapper());

final seedToWorkTypeMapper =
    Provider<Mapper<int, sources.WorkType>>((ref) => SeedToWorkTypeMapper());

final seedToReadingDirectionMapper =
    Provider<Mapper<int, sources.ReadingDirection>>(
        (ref) => SeedToReadingDirectionMapper());

// Companions.

final sourceToNovelCompanionMapper =
    Provider<Mapper<sources.Novel, NovelsCompanion>>(
  (ref) => SourceToNovelCompanionMapper(
    statusMapper: ref.watch(novelStatusToSeedMapper),
    workTypeMapper: ref.watch(workTypeToSeedMapper),
    readingDirectionMapper: ref.watch(readingDirectionToSeedMapper),
  ),
);

final sourceToVolumeCompanionMapper =
    Provider<Mapper<sources.Volume, VolumesCompanion>>(
        (ref) => SourceToVolumeCompanionMapper());

final sourceToChapterCompanionMapper =
    Provider<Mapper<sources.Chapter, ChaptersCompanion>>(
        (ref) => SourceToChapterCompanionMapper());

// Models.
final databaseToNovelMapper =
    Provider<Mapper<Novel, NovelEntity>>((ref) => DatabaseToNovelMapper(
          statusMapper: ref.watch(seedToNovelStatusMapper),
          readingDirectionMapper: ref.watch(seedToReadingDirectionMapper),
          workTypeMapper: ref.watch(seedToWorkTypeMapper),
        ));
