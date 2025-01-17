import 'package:nacht/core/core.dart';
import 'package:nacht_sources/nacht_sources.dart';
import 'package:flutter/material.dart';

class StatusLine extends StatelessWidget {
  const StatusLine({
    Key? key,
    required this.status,
    this.suffix,
  }) : super(key: key);

  final NovelStatus status;
  final String? suffix;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        buildIcon(),
        const SizedBox(width: 4.0),
        Text(
          buildStatusLabel() + buildSuffix(),
          style: Theme.of(context).textTheme.bodyMedium,
          maxLines: 1,
        ),
      ],
    );
  }

  Widget buildIcon() {
    final IconData iconData;
    switch (status) {
      case NovelStatus.ongoing:
        iconData = Icons.timelapse;
        break;
      case NovelStatus.hiatus:
        iconData = Icons.pause;
        break;
      case NovelStatus.completed:
        iconData = Icons.check;
        break;
      case NovelStatus.stub:
        iconData = Icons.cut;
        break;
      case NovelStatus.unknown:
        iconData = Icons.question_mark;
        break;
    }

    return Icon(
      iconData,
      size: 16,
    );
  }

  String buildStatusLabel() {
    return status.name.capitalize();
  }

  String buildSuffix() {
    return suffix != null ? ' • $suffix' : '';
  }
}
