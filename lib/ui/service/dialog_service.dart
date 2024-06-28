import 'package:flutter/widgets.dart';

import '../../dependency_injection.dart';
import '../component/confirmation_dialog_component.dart';
import '../config/app_router.dart';

Future<bool> askForConfirmation({
  required String title,
  required String message,
}) async =>
    await showAlertDialog(
      ConfirmationDialogComponent(
        title: title,
        message: message,
      ),
      barrierDismissible: false,
    ) ==
    true;

Future<T?> showAlertDialog<T>(
  Widget dialog, {
  bool barrierDismissible = true,
}) async {
  final BuildContext? context = getIt<AppRouter>().navigatorKey.currentContext;
  if (context == null) return null;
  return await showGeneralDialog<T>(
    context: context,
    pageBuilder: (_, anim1, anim2) => dialog,
    transitionBuilder: (BuildContext context, anim1, anim2, child) {
      var curve = Curves.easeInOutQuart.transform(anim1.value);
      return Transform.scale(
        scale: curve,
        child: child,
      );
    },
    transitionDuration: const Duration(milliseconds: 250),
    barrierDismissible: barrierDismissible,
    barrierLabel: '',
  );
}
