import 'package:chapturn/domain/usecases/category/change_novel_categories.dart';
import 'package:chapturn/domain/usecases/category/get_all_categories.dart';
import 'package:chapturn_sources/chapturn_sources.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

import '../../../../domain/entities/novel/novel_entity.dart';
import '../../../../domain/entities/novel/partial_novel_entity.dart';
import '../../../../domain/usecases/parse_or_get_novel.dart';
import 'novel_page_notice.dart';
import 'providers.dart';

part 'novel_page_state.freezed.dart';

@freezed
class NovelPageState with _$NovelPageState {
  factory NovelPageState.partial(PartialNovelEntity entity) = _NovelPagePartial;
  factory NovelPageState.loaded(NovelEntity entity) = _NovelPageLoaded;
}

class NovelPageController extends StateNotifier<NovelPageState> {
  NovelPageController({
    required NovelPageState initial,
    required this.crawler,
    required this.read,
    required this.parseOrGetNovel,
    required this.getAllCategories,
    required this.changeNovelCategories,
  }) : super(initial);

  final Crawler? crawler;
  final Reader read;

  final ParseOrGetNovel parseOrGetNovel;
  final GetAllCategories getAllCategories;
  final ChangeNovelCategories changeNovelCategories;

  final _log = Logger('NovelPageController');

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

    _log.info('Start parse or get novel.');
    final result = await parseOrGetNovel.execute(crawler as ParseNovel, url);
    _log.info('End parse or get novel.');

    result.fold(
      (failure) => _notice.error('An error occured'),
      (data) => state = NovelPageState.loaded(data),
    );
  }

  Future<void> addToLibrary() async {}

  Future<void> removeFromLibrary() async {}
}
