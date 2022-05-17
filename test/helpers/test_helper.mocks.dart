// Mocks generated by Mockito 5.1.0 from annotations
// in chapturn/test/helpers/test_helper.dart.
// Do not manually edit this file.

import 'dart:async' as _i6;

import 'package:chapturn/core/failure.dart' as _i5;
import 'package:chapturn/domain/domain.dart' as _i4;
import 'package:chapturn/domain/entities/network/network_connection_data.dart'
    as _i7;
import 'package:chapturn_sources/chapturn_sources.dart' as _i3;
import 'package:dartz/dartz.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types

class _FakeOption_0<A> extends _i1.Fake implements _i2.Option<A> {}

class _FakeEither_1<L, R> extends _i1.Fake implements _i2.Either<L, R> {}

class _FakeNovel_2 extends _i1.Fake implements _i3.Novel {}

/// A class which mocks [CrawlerRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockCrawlerRepository extends _i1.Mock implements _i4.CrawlerRepository {
  MockCrawlerRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.Option<_i3.CrawlerFactory> crawlerFactoryFor(String? url) =>
      (super.noSuchMethod(Invocation.method(#crawlerFactoryFor, [url]),
              returnValue: _FakeOption_0<_i3.CrawlerFactory>())
          as _i2.Option<_i3.CrawlerFactory>);
  @override
  _i2.Either<_i5.Failure, List<_i3.CrawlerFactory>> getAllCrawlers() =>
      (super.noSuchMethod(Invocation.method(#getAllCrawlers, []),
              returnValue:
                  _FakeEither_1<_i5.Failure, List<_i3.CrawlerFactory>>())
          as _i2.Either<_i5.Failure, List<_i3.CrawlerFactory>>);
  @override
  _i6.Future<
      _i2.Either<_i5.Failure, List<_i4.PartialNovelData>>> getPopularNovels(
          _i3.ParsePopular? parser, int? page) =>
      (super.noSuchMethod(Invocation.method(#getPopularNovels, [parser, page]),
          returnValue:
              Future<_i2.Either<_i5.Failure, List<_i4.PartialNovelData>>>.value(
                  _FakeEither_1<_i5.Failure, List<_i4.PartialNovelData>>())) as _i6
          .Future<_i2.Either<_i5.Failure, List<_i4.PartialNovelData>>>);
}

/// A class which mocks [ParseNovel].
///
/// See the documentation for Mockito's code generation for more information.
class MockParseNovel extends _i1.Mock implements _i3.ParseNovel {
  MockParseNovel() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i6.Future<_i3.Novel> parseNovel(String? url) =>
      (super.noSuchMethod(Invocation.method(#parseNovel, [url]),
              returnValue: Future<_i3.Novel>.value(_FakeNovel_2()))
          as _i6.Future<_i3.Novel>);
  @override
  _i6.Future<void> parseChapter(_i3.Chapter? chapter) =>
      (super.noSuchMethod(Invocation.method(#parseChapter, [chapter]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i6.Future<void>);
}

/// A class which mocks [ParsePopular].
///
/// See the documentation for Mockito's code generation for more information.
class MockParsePopular extends _i1.Mock implements _i3.ParsePopular {
  MockParsePopular() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i6.Future<List<_i3.Novel>> parsePopular(int? page) =>
      (super.noSuchMethod(Invocation.method(#parsePopular, [page]),
              returnValue: Future<List<_i3.Novel>>.value(<_i3.Novel>[]))
          as _i6.Future<List<_i3.Novel>>);
}

/// A class which mocks [GatewayRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockGatewayRepository extends _i1.Mock implements _i4.GatewayRepository {
  MockGatewayRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i6.Future<_i2.Either<_i5.Failure, _i3.Novel>> parseNovel(
          _i3.ParseNovel? parser, String? url) =>
      (super.noSuchMethod(Invocation.method(#parseNovel, [parser, url]),
              returnValue: Future<_i2.Either<_i5.Failure, _i3.Novel>>.value(
                  _FakeEither_1<_i5.Failure, _i3.Novel>()))
          as _i6.Future<_i2.Either<_i5.Failure, _i3.Novel>>);
}

/// A class which mocks [NovelRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockNovelRepository extends _i1.Mock implements _i4.NovelRepository {
  MockNovelRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i6.Future<_i2.Either<_i5.Failure, _i4.NovelData>> getNovel(int? id) =>
      (super.noSuchMethod(Invocation.method(#getNovel, [id]),
              returnValue: Future<_i2.Either<_i5.Failure, _i4.NovelData>>.value(
                  _FakeEither_1<_i5.Failure, _i4.NovelData>()))
          as _i6.Future<_i2.Either<_i5.Failure, _i4.NovelData>>);
  @override
  _i6.Future<_i2.Either<_i5.Failure, _i4.NovelData>> getNovelByUrl(
          String? url) =>
      (super.noSuchMethod(Invocation.method(#getNovelByUrl, [url]),
              returnValue: Future<_i2.Either<_i5.Failure, _i4.NovelData>>.value(
                  _FakeEither_1<_i5.Failure, _i4.NovelData>()))
          as _i6.Future<_i2.Either<_i5.Failure, _i4.NovelData>>);
  @override
  _i6.Future<_i2.Either<_i5.Failure, List<int>>> updateNovel(
          _i3.Novel? novel) =>
      (super.noSuchMethod(Invocation.method(#updateNovel, [novel]),
              returnValue: Future<_i2.Either<_i5.Failure, List<int>>>.value(
                  _FakeEither_1<_i5.Failure, List<int>>()))
          as _i6.Future<_i2.Either<_i5.Failure, List<int>>>);
  @override
  _i6.Future<void> setFavourite(int? novelId, bool? value) =>
      (super.noSuchMethod(Invocation.method(#setFavourite, [novelId, value]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i6.Future<void>);
  @override
  _i6.Future<void> setCover(int? novelId, _i4.AssetData? asset) =>
      (super.noSuchMethod(Invocation.method(#setCover, [novelId, asset]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i6.Future<void>);
}

/// A class which mocks [NetworkRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockNetworkRepository extends _i1.Mock implements _i4.NetworkRepository {
  MockNetworkRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i6.Future<_i7.NetworkConnectionType> getConnectionStatus() =>
      (super.noSuchMethod(Invocation.method(#getConnectionStatus, []),
              returnValue: Future<_i7.NetworkConnectionType>.value(
                  _i7.NetworkConnectionType.none))
          as _i6.Future<_i7.NetworkConnectionType>);
  @override
  _i6.Future<bool> isConnectionAvailable() =>
      (super.noSuchMethod(Invocation.method(#isConnectionAvailable, []),
          returnValue: Future<bool>.value(false)) as _i6.Future<bool>);
}

/// A class which mocks [CategoryRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockCategoryRepository extends _i1.Mock
    implements _i4.CategoryRepository {
  MockCategoryRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i6.Future<_i2.Either<_i5.Failure, _i4.CategoryData>> add(
          int? index, String? name) =>
      (super.noSuchMethod(Invocation.method(#add, [index, name]),
          returnValue: Future<_i2.Either<_i5.Failure, _i4.CategoryData>>.value(
              _FakeEither_1<_i5.Failure, _i4.CategoryData>())) as _i6
          .Future<_i2.Either<_i5.Failure, _i4.CategoryData>>);
  @override
  _i6.Future<_i2.Either<_i5.Failure, void>> edit(_i4.CategoryData? category) =>
      (super.noSuchMethod(Invocation.method(#edit, [category]),
              returnValue: Future<_i2.Either<_i5.Failure, void>>.value(
                  _FakeEither_1<_i5.Failure, void>()))
          as _i6.Future<_i2.Either<_i5.Failure, void>>);
  @override
  _i6.Future<_i2.Either<_i5.Failure, void>> updateIndex(
          List<_i4.CategoryData>? categories) =>
      (super.noSuchMethod(Invocation.method(#updateIndex, [categories]),
              returnValue: Future<_i2.Either<_i5.Failure, void>>.value(
                  _FakeEither_1<_i5.Failure, void>()))
          as _i6.Future<_i2.Either<_i5.Failure, void>>);
  @override
  _i6.Future<List<_i4.CategoryData>> getAllCategories() =>
      (super.noSuchMethod(Invocation.method(#getAllCategories, []),
              returnValue:
                  Future<List<_i4.CategoryData>>.value(<_i4.CategoryData>[]))
          as _i6.Future<List<_i4.CategoryData>>);
  @override
  _i6.Future<List<_i4.CategoryData>> getCategoriesOfNovel(
          _i4.NovelData? novel) =>
      (super.noSuchMethod(Invocation.method(#getCategoriesOfNovel, [novel]),
              returnValue:
                  Future<List<_i4.CategoryData>>.value(<_i4.CategoryData>[]))
          as _i6.Future<List<_i4.CategoryData>>);
  @override
  _i6.Future<void> changeNovelCategories(
          _i4.NovelData? novel, Map<_i4.CategoryData, bool>? categories) =>
      (super.noSuchMethod(
          Invocation.method(#changeNovelCategories, [novel, categories]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i6.Future<void>);
  @override
  _i6.Future<List<_i4.NovelData>> getNovelsOfCategory(
          _i4.CategoryData? category) =>
      (super.noSuchMethod(Invocation.method(#getNovelsOfCategory, [category]),
              returnValue: Future<List<_i4.NovelData>>.value(<_i4.NovelData>[]))
          as _i6.Future<List<_i4.NovelData>>);
  @override
  _i6.Future<_i2.Either<_i5.Failure, void>> remove(Iterable<int>? ids) =>
      (super.noSuchMethod(Invocation.method(#remove, [ids]),
              returnValue: Future<_i2.Either<_i5.Failure, void>>.value(
                  _FakeEither_1<_i5.Failure, void>()))
          as _i6.Future<_i2.Either<_i5.Failure, void>>);
}

/// A class which mocks [AssetRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockAssetRepository extends _i1.Mock implements _i4.AssetRepository {
  MockAssetRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i6.Future<_i2.Either<_i5.Failure, _i4.AssetData>> addAsset(
          String? directory, _i4.AssetInfo? data, [String? url]) =>
      (super.noSuchMethod(Invocation.method(#addAsset, [directory, data, url]),
              returnValue: Future<_i2.Either<_i5.Failure, _i4.AssetData>>.value(
                  _FakeEither_1<_i5.Failure, _i4.AssetData>()))
          as _i6.Future<_i2.Either<_i5.Failure, _i4.AssetData>>);
  @override
  _i6.Future<_i2.Either<_i5.Failure, _i4.AssetInfo>> downloadAsset(
          String? url) =>
      (super.noSuchMethod(Invocation.method(#downloadAsset, [url]),
              returnValue: Future<_i2.Either<_i5.Failure, _i4.AssetInfo>>.value(
                  _FakeEither_1<_i5.Failure, _i4.AssetInfo>()))
          as _i6.Future<_i2.Either<_i5.Failure, _i4.AssetInfo>>);
  @override
  _i6.Future<_i2.Either<_i5.Failure, void>> deleteAsset(_i4.AssetData? asset) =>
      (super.noSuchMethod(Invocation.method(#deleteAsset, [asset]),
              returnValue: Future<_i2.Either<_i5.Failure, void>>.value(
                  _FakeEither_1<_i5.Failure, void>()))
          as _i6.Future<_i2.Either<_i5.Failure, void>>);
  @override
  _i6.Future<_i2.Either<_i5.Failure, _i4.AssetData>> getAsset(int? assetId) =>
      (super.noSuchMethod(Invocation.method(#getAsset, [assetId]),
              returnValue: Future<_i2.Either<_i5.Failure, _i4.AssetData>>.value(
                  _FakeEither_1<_i5.Failure, _i4.AssetData>()))
          as _i6.Future<_i2.Either<_i5.Failure, _i4.AssetData>>);
}
