import 'package:dartz/dartz.dart';
import 'package:drift/drift.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nacht/core/core.dart';
import 'package:nacht/shared/shared.dart';
import 'package:nacht/database/database.dart';

final parseNovelQueryProvider = Provider<ParseNovelQuery>(
  (ref) => ParseNovelQuery(
    database: ref.watch(databaseProvider),
  ),
  name: 'ParseNovelQueryProvider',
);

/// Parse the provided [query] by fetching metadata and chapters
/// from database as requried.
class ParseNovelQuery {
  ParseNovelQuery({
    required AppDatabase database,
  }) : _database = database;

  final AppDatabase _database;

  Future<Either<Failure, NovelData>> execute(
    JoinedSelectStatement<HasResultSet, dynamic> query,
  ) async {
    final result = await query.getSingleOrNull();
    if (result == null) {
      return const Left(NovelNotFound());
    }

    final novel = result.readTable(_database.novels);
    final asset = result.readTableOrNull(_database.assets);

    final entity = NovelData.fromModel(novel).copyWith(
      cover: asset == null ? null : AssetData.fromModel(asset),
    );

    return Right(entity);
  }
}
