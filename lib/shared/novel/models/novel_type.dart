import 'package:freezed_annotation/freezed_annotation.dart';

import '../novel.dart';

part 'novel_type.freezed.dart';

@freezed
class NovelType with _$NovelType {
  factory NovelType.url(String url) = _UrlData;
  factory NovelType.partial(PartialNovelData partial) = _PartialData;
  factory NovelType.novel(NovelData novel) = _CompleteData;

  String get url {
    return when(
      url: (url) => url,
      partial: (partial) => partial.url,
      novel: (novel) => novel.url,
    );
  }

  NovelType._();
}
