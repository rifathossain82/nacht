// Mocks generated by Mockito 5.3.0 from annotations
// in nacht/test/helpers/test_helper.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:mockito/mockito.dart' as _i1;
import 'package:nacht_sources/src/mixins/parse_novel.dart' as _i3;
import 'package:nacht_sources/src/models/models.dart' as _i2;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeNovel_0 extends _i1.SmartFake implements _i2.Novel {
  _FakeNovel_0(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

/// A class which mocks [ParseNovel].
///
/// See the documentation for Mockito's code generation for more information.
class MockParseNovel extends _i1.Mock implements _i3.ParseNovel {
  MockParseNovel() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<_i2.Novel> fetchNovel(String? url) =>
      (super.noSuchMethod(Invocation.method(#fetchNovel, [url]),
              returnValue: _i4.Future<_i2.Novel>.value(
                  _FakeNovel_0(this, Invocation.method(#fetchNovel, [url]))))
          as _i4.Future<_i2.Novel>);
  @override
  _i4.Future<String?> fetchChapterContent(String? url) =>
      (super.noSuchMethod(Invocation.method(#fetchChapterContent, [url]),
          returnValue: _i4.Future<String?>.value()) as _i4.Future<String?>);
  @override
  _i4.Future<List<_i2.Novel>> search(String? query, int? page) =>
      (super.noSuchMethod(Invocation.method(#search, [query, page]),
              returnValue: _i4.Future<List<_i2.Novel>>.value(<_i2.Novel>[]))
          as _i4.Future<List<_i2.Novel>>);
  @override
  String buildPopularUrl(int? page) =>
      (super.noSuchMethod(Invocation.method(#buildPopularUrl, [page]),
          returnValue: '') as String);
  @override
  _i4.Future<List<_i2.Novel>> fetchPopular(int? page) =>
      (super.noSuchMethod(Invocation.method(#fetchPopular, [page]),
              returnValue: _i4.Future<List<_i2.Novel>>.value(<_i2.Novel>[]))
          as _i4.Future<List<_i2.Novel>>);
}
