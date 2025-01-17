import 'package:nacht/shared/shared.dart';
import 'package:nacht_sources/nacht_sources.dart' as sources;
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:nacht/database/database.dart';

part 'novel_data.freezed.dart';

@freezed
class NovelData with _$NovelData {
  factory NovelData({
    required int id,
    required String title,
    required String url,
    required String? author,
    required List<String> description,
    required String? coverUrl,
    AssetData? cover,
    required sources.NovelStatus status,
    required String lang,
    required sources.WorkType workType,
    required sources.ReadingDirection readingDirection,
    required bool favourite,
  }) = _NovelData;

  factory NovelData.fromModel(Novel novel) {
    return NovelData(
      id: novel.id,
      title: novel.title,
      url: novel.url,
      author: novel.author,
      description: novel.description.split('\n'),
      coverUrl: novel.coverUrl,
      status: StatusSeed.intoStatus(novel.statusId),
      lang: novel.lang,
      workType: WorkTypeSeed.intoWorkType(novel.workTypeId),
      readingDirection:
          ReadingDirectionSeed.intoReadingDirection(novel.readingDirectionId),
      favourite: novel.favourite,
    );
  }

  NovelData._();
}
