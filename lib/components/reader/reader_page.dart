import 'package:chapturn/components/reader/provider/toolbar_provider.dart';
import 'package:chapturn/core/core.dart';
import 'package:chapturn/extrinsic/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../domain/domain.dart';
import 'provider/active_chapter_provider.dart';
import 'provider/reader_novel_provider.dart';
import 'widgets/reader_body.dart';

class ReaderPage extends HookConsumerWidget {
  const ReaderPage({
    Key? key,
    required this.novel,
    required this.chapter,
  }) : super(key: key);

  final NovelData novel;
  final ChapterData chapter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final novelInfo = ref.watch(readerNovelProvider(novel));
    final toolbarVisible =
        ref.watch(toolbarProvider.select((toolbar) => toolbar.visible));

    final controller = useAnimationController(
      duration: const Duration(milliseconds: 300),
    );

    return WillPopScope(
      onWillPop: () async {
        ref.read(toolbarProvider.notifier).show();
        return true;
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: SlidingPrefferedSize(
          controller: controller,
          visible: toolbarVisible,
          child: AppBar(
            title: Consumer(builder: (context, ref, child) {
              final active = ref.watch(activeChapterProvider(novelInfo));

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    novel.title,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: theme.appBarTheme.foregroundColor,
                    ),
                    maxLines: 1,
                  ),
                  Text(
                    active?.title ?? chapter.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.hintColor,
                    ),
                    maxLines: 1,
                  ),
                ],
              );
            }),
          ),
        ),
        body: ReaderBody(novel: novelInfo, chapter: chapter),
      ),
    );
  }
}
