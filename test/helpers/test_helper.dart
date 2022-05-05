import 'package:chapturn/domain/domain.dart';
import 'package:chapturn_sources/chapturn_sources.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([
  CrawlerRepository,
  ParseNovel,
  ParsePopular,
  GatewayRepository,
  NovelRepository,
  NetworkRepository,
  CategoryRepository,
  AssetRepository,
])
void main() {}
