import 'package:chapturn/data/data.dart';
import 'package:chapturn/domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tChapter = Chapter(
    id: 2,
    chapterIndex: 2,
    title: 'my chapter',
    content: null,
    url: 'https://website.com/novel/123/1',
    updated: DateTime(2022, 4, 23),
    volumeId: 2,
  );

  final tData = ChapterData(
    id: 2,
    index: 2,
    title: 'my chapter',
    content: null,
    url: 'https://website.com/novel/123/1',
    updated: DateTime(2022, 4, 23),
    volumeId: 2,
  );

  test('should create chapter data from data.chapter', () {
    final result = ChapterData.fromModel(tChapter);
    expect(result, tData);
  });
}