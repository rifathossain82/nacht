import 'package:nacht/shared/shared.dart';
import 'package:nacht/core/core.dart';
import 'package:nacht_sources/nacht_sources.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../main/main.dart';
import '../services/services.dart';

final searchFetchProvider = StateNotifierProvider.autoDispose
    .family<SearchFetchNotifier, FetchInfo, CrawlerInfo>(
  (ref, holding) {
    var notifier = SearchFetchNotifier(
      ref: ref,
      crawler: holding,
      fetchSearch: ref.watch(fetchSearchProvider),
    );

    return notifier;
  },
  name: 'SearchFetchProvider',
);

class SearchFetchNotifier extends StateNotifier<FetchInfo> with LoggerMixin {
  SearchFetchNotifier({
    required Ref ref,
    required CrawlerInfo crawler,
    required FetchSearch fetchSearch,
  })  : _ref = ref,
        _crawler = crawler,
        _fetchSearch = fetchSearch,
        super(FetchInfo.initial());

  String _currentQuery = '';

  final Ref _ref;
  final CrawlerInfo _crawler;
  final FetchSearch _fetchSearch;

  void restart(CrawlerInfo crawler) {
    state = FetchInfo.initial().copyWith(isLoading: true);
    next(crawler);
  }

  Future<void> next(CrawlerInfo crawler) {
    return fetch(crawler, _currentQuery);
  }

  Future<void> fetch(CrawlerInfo crawler, String query) async {
    if (!crawler.isSupported(Feature.search)) {
      log.warning('crawler search cancelled, not supported');
      return;
    }

    if (query == _currentQuery) {
      state = state.copyWith(isLoading: true);
    } else {
      _currentQuery = query;
      state = FetchInfo.initial().copyWith(isLoading: true);
    }

    final result =
        await _fetchSearch.execute(_crawler.isolate, _currentQuery, state.page);

    result.fold(
      (failure) {
        if (state.page == 1) {
          state = state.copyWith(error: failure.message, isLoading: false);
        } else {
          state = state.copyWith(isLoading: false);
          _ref.read(messageServiceProvider).showText(failure.message);
        }
      },
      (data) {
        state = state.copyWith(
          data: [...state.data, ...data],
          isLoading: false,
          page: state.page + 1,
        );
      },
    );
  }
}
