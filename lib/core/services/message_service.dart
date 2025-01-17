import 'package:fluttertoast/fluttertoast.dart';
import 'package:nacht/core/core.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final messageServiceProvider = Provider<MessageService>(
  (ref) => MessageService(ref: ref),
  name: 'MessageServiceProvider',
);

class MessageService {
  MessageService({
    required Ref ref,
  }) : _ref = ref;

  final Ref _ref;

  BuildContext _getContext() {
    final context = _ref.read(routerProvider).navigatorKey.currentContext;
    assert(context != null);
    return context!;
  }

  Future<void> showToast(String message, {Toast? toastLength}) {
    return Fluttertoast.showToast(msg: message, toastLength: toastLength);
  }

  Future<void> hideToast() {
    return Fluttertoast.cancel();
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason>? showText(
    String text,
  ) {
    return showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> showUndo(
    String message, {
    required VoidCallback onUndo,
    required VoidCallback orElse,
    Duration duration = const Duration(seconds: 2),
  }) async {
    final handle = showSnackBar(
      SnackBar(
        content: Text(message),
        action: SnackBarAction(label: 'Undo', onPressed: onUndo),
      ),
    );

    switch (await handle.closed) {
      case SnackBarClosedReason.action:
        return;
      default:
        orElse();
        break;
    }
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBar(
    SnackBar snackBar,
  ) {
    final context = _getContext();

    final messenger = ScaffoldMessenger.maybeOf(context);
    assert(messenger != null);

    return messenger!.showSnackBar(snackBar);
  }
}
