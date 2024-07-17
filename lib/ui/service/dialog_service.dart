import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../component/confirmation_dialog_component.dart';
import '../component/loading_dialog_component.dart';
import '../component/message_dialog_component.dart';
import '../config/app_router.dart';

@Singleton()
class DialogService {
  final AppRouter _appRouter;
  bool _isLoadingDialogOpened = false;

  DialogService(this._appRouter);

  void showLoadingDialog() {
    final BuildContext? context = _appRouter.navigatorKey.currentContext;
    if (!_isLoadingDialogOpened && context != null) {
      _isLoadingDialogOpened = true;
      showDialog(
        context: context,
        builder: (_) => const LoadingDialog(),
        barrierDismissible: false,
      );
    }
  }

  void showSnackbarMessage(String message) {
    final BuildContext? context = _appRouter.navigatorKey.currentContext;
    if (context != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
    }
  }

  Future<void> showMessageDialog({
    required String title,
    required String message,
  }) async {
    await _showAlertDialog(
      MessageDialog(
        title: title,
        message: message,
      ),
    );
  }

  Future<bool> askForConfirmation({
    required String title,
    required String message,
  }) async =>
      await _showAlertDialog(
        ConfirmationDialogComponent(
          title: title,
          message: message,
        ),
        barrierDismissible: false,
      ) ==
      true;

  void closeLoadingDialog() {
    final BuildContext? context = _appRouter.navigatorKey.currentContext;
    if (_isLoadingDialogOpened && context != null) {
      Navigator.of(context, rootNavigator: true).pop();
      _isLoadingDialogOpened = false;
    }
  }

  Future<T?> _showAlertDialog<T>(
    Widget dialog, {
    bool barrierDismissible = true,
  }) async {
    final BuildContext? context = _appRouter.navigatorKey.currentContext;
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
}
