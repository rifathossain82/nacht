import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nacht/core/core.dart';

class DateUpdateTile extends ConsumerWidget {
  const DateUpdateTile({
    Key? key,
    required this.date,
  }) : super(key: key);

  final DateTime date;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context);

    final dateFormatService = ref.watch(dateFormatServiceFamily(locale));

    return ListTile(
      title: Text(
        dateFormatService.relativeDay(date),
        style: theme.textTheme.labelLarge,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      dense: true,
    );
  }
}
