import 'package:chapturn_sources/chapturn_sources.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/core.dart';
import '../../../domain/entities/novel/novel_data.dart';
import '../../../domain/entities/novel/partial_novel_data.dart';
import '../../../../domain/usecases/novel/download_novel_cover.dart';
import '../../../../domain/usecases/novel/parse_or_get_novel.dart';
import 'novel_page_notice.dart';
import 'providers.dart';

part 'novel_page_state.freezed.dart';

@freezed
class NovelPageState with _$NovelPageState {
  factory NovelPageState.partial(PartialNovelData entity) = _NovelPagePartial;
  factory NovelPageState.loaded(NovelData entity) = _NovelPageLoaded;
}

class NovelPageController extends StateNotifier<NovelPageState>
    with LoggerMixin {
  NovelPageController({
    required NovelPageState initial,
    required this.crawler,
    required this.read,
    required this.parseOrGetNovel,
    required this.downloadNovelCover,
  }) : super(initial);

  final Crawler? crawler;
  final Reader read;

  final ParseOrGetNovel parseOrGetNovel;
  final DownloadNovelCover downloadNovelCover;

  NoticeController get _notice => read(noticeProvider.notifier);

  Future<void> reload() async {
    final url = state.when(
      partial: (novel) => novel.url,
      loaded: (novel) => novel.url,
    );

    if (crawler == null || crawler is! ParseNovel) {
      _notice.error('Unable to parse.');
      return;
    }

    log.info('Start parse or get novel.');
    final result = await parseOrGetNovel.execute(crawler as ParseNovel, url);
    log.info('End parse or get novel.');

    result.fold(
      (failure) => _notice.error('An error occured'),
      (data) async {
        state = NovelPageState.loaded(data);

        log.info('Downloading cover.');
        final coverResult = await downloadNovelCover.execute(data);
        coverResult.fold(
          (failure) => {},
          (cover) => state = NovelPageState.loaded(
            data.copyWith(cover: cover),
          ),
        );
      },
    );
  }
}
