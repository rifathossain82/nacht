import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'data/navigation.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter(
      lazyLoad: false,
      homeIndex: 0,
      routes: navigationItems.map((item) => item.route).toList(),
      builder: (context, child, animation) {
        final tabsRouter = AutoTabsRouter.of(context);

        return Scaffold(
          body: child,
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: tabsRouter.activeIndex,
            onTap: (index) => tabsRouter.setActiveIndex(index),
            items: List.generate(navigationItems.length, (index) {
              final item = navigationItems[index];

              return BottomNavigationBarItem(
                icon: Icon(item.iconData),
                label: item.label,
              );
            }),
            type: BottomNavigationBarType.fixed,
          ),
        );
      },
    );
  }
}
