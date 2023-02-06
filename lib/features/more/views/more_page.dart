import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nacht/core/core.dart';
import 'package:flutter/material.dart';
import 'package:nacht/features/features.dart';

class MorePage extends HookConsumerWidget {
  const MorePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('More'),
      ),
      body: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView(
          padding: const EdgeInsets.all(0),
          children: [
            Consumer(
              builder: (context, ref, child) {
                final remaining = ref.watch(
                    downloadListProvider.select((state) => state.order.length));

                return ListTile(
                  leading: const Icon(Icons.download),
                  title: const Text('Download queue'),
                  subtitle: remaining > 0 ? Text("$remaining remaining") : null,
                  onTap: () => context.router.push(const DownloadRoute()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.category),
              title: const Text('Categories'),
              onTap: () => context.router.push(const CategoryRoute()),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () => context.router.push(const SettingsRoute()),
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About'),
              onTap: () => context.router.push(const AboutRoute()),
            ),
            const NavigationOffset(),
          ],
        ),
      ),
    );
  }
}
