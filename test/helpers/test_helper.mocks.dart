// Mocks generated by Mockito 5.1.0 from annotations
// in chapturn/test/helpers/test_helper.dart.
// Do not manually edit this file.

import 'dart:async' as _i6;

import 'package:chapturn/core/failure.dart' as _i4;
import 'package:chapturn/domain/entities/entities.dart' as _i7;
import 'package:chapturn/domain/repositories/crawler_repository.dart' as _i3;
import 'package:chapturn_sources/chapturn_sources.dart' as _i5;
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

class _FakeEither_0<L, R> extends _i1.Fake implements _i2.Either<L, R> {}

/// A class which mocks [CrawlerRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockCrawlerRepository extends _i1.Mock implements _i3.CrawlerRepository {
  MockCrawlerRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.Either<_i4.Failure, _i5.CrawlerFactory> crawlerFactoryFor(String? url) =>
      (super.noSuchMethod(Invocation.method(#crawlerFactoryFor, [url]),
              returnValue: _FakeEither_0<_i4.Failure, _i5.CrawlerFactory>())
          as _i2.Either<_i4.Failure, _i5.CrawlerFactory>);
  @override
  _i2.Either<_i4.Failure, List<_i5.CrawlerFactory>> getAllCrawlers() =>
      (super.noSuchMethod(Invocation.method(#getAllCrawlers, []),
              returnValue:
                  _FakeEither_0<_i4.Failure, List<_i5.CrawlerFactory>>())
          as _i2.Either<_i4.Failure, List<_i5.CrawlerFactory>>);
  @override
  _i6.Future<_i2.Either<_i4.Failure, List<_i7.PartialNovelEntity>>>
      getPopularNovels(_i5.NovelPopular? parser) => (super.noSuchMethod(
          Invocation.method(#getPopularNovels, [parser]),
          returnValue: Future<
                  _i2.Either<_i4.Failure, List<_i7.PartialNovelEntity>>>.value(
              _FakeEither_0<_i4.Failure, List<_i7.PartialNovelEntity>>())) as _i6
          .Future<_i2.Either<_i4.Failure, List<_i7.PartialNovelEntity>>>);
}

/// A class which mocks [NovelPopular].
///
/// See the documentation for Mockito's code generation for more information.
class MockNovelPopular extends _i1.Mock implements _i5.NovelPopular {
  MockNovelPopular() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i6.Future<List<_i5.Novel>> parsePopular(int? page) =>
      (super.noSuchMethod(Invocation.method(#parsePopular, [page]),
              returnValue: Future<List<_i5.Novel>>.value(<_i5.Novel>[]))
          as _i6.Future<List<_i5.Novel>>);
}
