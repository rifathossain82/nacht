import 'package:chapturn/core/core.dart';
import 'package:chapturn_sources/chapturn_sources.dart' as sources;
import 'package:dartz/dartz.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../domain.dart';

final sourceServiceProvider = Provider<SourceService>(
  (ref) => SourceService(
    crawlerRepository: ref.watch(crawlerRepositoryProvider),
  ),
  name: 'SourceServiceProvider',
);

class SourceService with LoggerMixin {
  SourceService({
    required CrawlerRepository crawlerRepository,
  }) : _crawlerRepository = crawlerRepository;

  final CrawlerRepository _crawlerRepository;

  Option<sources.CrawlerFactory> crawlerFactoryFor({required String url}) {
    return _crawlerRepository.crawlerFactoryFor(url);
  }

  Either<Failure, List<sources.CrawlerFactory>> crawlers() {
    return _crawlerRepository.getAllCrawlers();
  }

  Future<Either<Failure, List<PartialNovelData>>> popular(
    sources.ParsePopular parser,
    int page,
  ) async {
    return _crawlerRepository.getPopularNovels(parser, page);
  }
}
