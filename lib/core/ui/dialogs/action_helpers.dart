import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/widgets.dart' as fw;
import 'package:store/core/ui/kit/app_kit.dart';

import '../../results/result.dart';
import 'dialogs.dart';
import 'package:easy_localization/easy_localization.dart';

/// Shows a simple confirm / cancel dialog and calls [onConfirm] when the
/// user confirms. Use [destructive] for delete / cancel style actions.
void showConfirmDialog(
  fw.BuildContext context, {
  required String title,
  required String message,
  required String confirmLabel,
  required fw.VoidCallback onConfirm,
  bool destructive = false,
}) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        OutlineButton(
          onPressed: () => fw.Navigator.pop(ctx),
          child: Text('cancel'.tr()),
        ),
        if (destructive)
          DestructiveButton(
            onPressed: () {
              fw.Navigator.pop(ctx);
              onConfirm();
            },
            child: Text(confirmLabel),
          )
        else
          PrimaryButton(
            onPressed: () {
              fw.Navigator.pop(ctx);
              onConfirm();
            },
            child: Text(confirmLabel),
          ),
      ],
    ),
  );
}

/// Runs an API action that returns a [Result], shows a success / error
/// snack bar and returns `true` when it succeeded.
Future<bool> runRemoteAction<T>(
  Future<Result<T>> Function() action, {
  required String successMessage,
}) async {
  final result = await action();
  if (result.hasErrorOnly) {
    Dialogs.showSnackBar(
      message: result.error ?? 'something_went_wrong'.tr(),
      typeSnackBar: AnimatedSnackBarType.error,
    );
    return false;
  }
  Dialogs.showSnackBar(message: successMessage);
  return true;
}
