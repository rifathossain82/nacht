import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nacht/features/features.dart';
import 'package:nacht/shared/shared.dart';
import 'package:nacht/core/core.dart';
import 'package:nacht/widgets/widgets.dart';
import 'package:share_plus/share_plus.dart';

import '../models/models.dart';
import '../providers/providers.dart';
import 'actions/download_action.dart';
import 'widgets.dart';

class NovelView extends HookConsumerWidget {
  const NovelView({
    Key? key,
    required this.data,
    required this.direct,
  }) : super(key: key);

  final NovelData data;
  final bool direct;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final refreshKey = useMemoized(() => GlobalKey<RefreshIndicatorState>());

    final input = NovelInput(data);
    final novel = ref.watch(novelFamily(input));
    final notifier = ref.watch(novelFamily(input).notifier);

    final crawlerFactory = ref.watch(crawlerFactoryFamily(novel.url));
    final crawler = crawlerFactory != null
        ? ref.watch(crawlerFamily(crawlerFactory))
        : null;

    final selection = ref.watch(novelSelectionProvider);
    SelectionNotifier.handleRoute(context, ref, novelSelectionProvider);

    final chapterList = ref.watch(chapterListFamily(data.id));
    final chapterListNotifier = ref.watch(chapterListFamily(data.id).notifier);

    useEffect(() {
      if (direct) {
        notifier.reload();
      }
      chapterListNotifier.init();
      return null;
    }, []);

    return Scaffold(
      appBar: selection.active
          ? SelectionAppBar(
              title: Text('${selection.selected.length}'),
              onSelectAllPressed: () => ref
                  .read(novelSelectionProvider.notifier)
                  .addAll(chapterList.ids),
              onInversePressed: () => ref
                  .read(novelSelectionProvider.notifier)
                  .flipAll(chapterList.ids),
            )
          : AppBar(
              title: Text(novel.title),
              actions: [
                DownloadAction(novel: novel),
                IconButton(
                  onPressed: () => showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    useSafeArea: true,
                    builder: (context) => const ChapterListBottomSheet(),
                  ),
                  icon: const Icon(Icons.filter_list),
                ),
                Consumer(
                  builder: (context, ref, child) {
                    final categoryCount = ref.watch(
                        categoriesProvider.select((value) => value.length));

                    return PopupMenuButton(
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          child: const Text('Refresh'),
                          onTap: () => refreshKey.currentState!.show(),
                        ),
                        if (categoryCount > 1)
                          PopupMenuItem(
                            child: const Text('Edit categories'),
                            onTap: () => notifier.editCategories(),
                          ),
                        PopupMenuItem(
                          child: const Text('Share'),
                          onTap: () => Share.share(novel.url),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
      body: RefreshIndicator(
        key: refreshKey,
        onRefresh: () async => notifier.fetch(crawler),
        child: Scrollbar(
          interactive: true,
          child: CustomScrollView(
            slivers: [
              buildPadding(
                sliver: NovelHead(head: HeadInfo.fromNovel(novel)),
                top: 24,
                bottom: 8,
              ),
              buildPadding(
                sliver: ActionBar(input: input),
                top: 0,
                bottom: 8,
              ),
              buildPadding(
                top: 0,
                bottom: 8,
                sliver: SliverToBoxAdapter(
                  child: DescriptionAndTags(
                    description: novel.description,
                    novelId: novel.id,
                    initialExpanded: !direct,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: ListTile(
                  title: Text(
                    '${chapterList.chapters.length} Chapter'.pluralize(
                      test: (_) => chapterList.chapters.length > 1,
                    ),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  trailing: const Icon(Icons.filter_list),
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      useSafeArea: true,
                      builder: (context) => const ChapterListBottomSheet(),
                    );
                  },
                  dense: true,
                ),
              ),
              ChapterList(novel: novel),
              SliverPadding(
                padding: EdgeInsets.only(
                  bottom:
                      kBottomBarHeight + MediaQuery.paddingOf(context).bottom,
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: selection.active
          ? null
          : FloatingActionButton(
              onPressed: notifier.readFirstUnread,
              child: const Icon(Icons.play_arrow),
            ),
      extendBody: true,
      bottomNavigationBar: ImplicitAnimatedBottomBar(
        visible: selection.active,
        child: CustomBottomBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.check),
                onPressed: () {
                  final selection = ref.read(novelSelectionProvider);
                  chapterListNotifier.setReadAt(selection.selected, true);
                  context.router.pop();
                },
                tooltip: 'Mark as read',
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  final selection = ref.read(novelSelectionProvider);
                  chapterListNotifier.setReadAt(selection.selected, false);
                  context.router.pop();
                },
                tooltip: 'Mark as unread',
              ),
              IconButton(
                onPressed: () {
                  final selection = ref.read(novelSelectionProvider);
                  final chapterList = ref.read(chapterListFamily(novel.id));
                  final chaptersToDownload = chapterList.chapters
                      .where(
                        (element) =>
                            element.content == null &&
                            selection.contains(element.id),
                      )
                      .map((e) => DownloadRelatedData.from(novel, e));

                  ref
                      .read(downloadListProvider.notifier)
                      .addMany(chaptersToDownload);
                  context.router.pop();
                },
                icon: const Icon(Icons.download),
                tooltip: 'Download',
              ),
              IconButton(
                onPressed: () {
                  final selection = ref.read(novelSelectionProvider);
                  final chapterList = ref.read(chapterListFamily(novel.id));
                  final chaptersToDelete = chapterList.chapters.where(
                    (element) =>
                        element.content != null &&
                        selection.contains(element.id),
                  );

                  ref
                      .read(deleteManyDownloadedChaptersProvider)
                      .call(chaptersToDelete);

                  context.router.pop();
                },
                icon: const Icon(Icons.delete),
                tooltip: 'Delete',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPadding({
    required Widget sliver,
    double left = 16.0,
    double top = 16.0,
    double right = 16.0,
    double bottom = 16.0,
  }) {
    return SliverPadding(
      padding: EdgeInsets.only(
        top: top,
        left: left,
        right: right,
        bottom: bottom,
      ),
      sliver: sliver,
    );
  }
}
