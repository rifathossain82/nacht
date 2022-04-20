import 'package:auto_route/auto_route.dart';
import 'package:chapturn/presentation/pages/pages.dart';
import 'package:chapturn_sources/chapturn_sources.dart';
import 'package:flutter/material.dart';

part 'app_router.gr.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: [
    AutoRoute(
      path: '/',
      page: HomePage,
      initial: true,
      children: [
        AutoRoute(page: LibraryPage),
        AutoRoute(page: UpdatesPage),
        AutoRoute(page: BrowsePage),
        AutoRoute(page: MorePage),
      ],
    ),
    AutoRoute(page: ImportFromUrlPage, path: 'import-from-url'),
    AutoRoute(
      page: PopularPage,
      path: 'popular',
    ),
  ],
)
class AppRouter extends _$AppRouter {}
