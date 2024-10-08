import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../component/confirmation_dialog_component.dart';
import '../component/loading_dialog_component.dart';
import '../component/message_dialog_component.dart';
import '../config/app_router.dart';
import '../extensions/context_extensions.dart';

@Singleton()
class DialogService {
  final AppRouter _appRouter;
  bool _isLoadingDialogOpened = false;
  bool _isDialogOpened = false;

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
    List<Widget>? actions,
    bool barrierDismissible = true,
  }) async {
    await _showAlertDialog(
      MessageDialog(
        title: title,
        message: message,
        actions: actions,
      ),
      barrierDismissible: barrierDismissible,
    );
  }

  Future<void> showLocationOffDialog({
    required VoidCallback onOpenDeviceLocationSettings,
  }) async {
    final BuildContext? context = _appRouter.navigatorKey.currentContext;
    if (context != null) {
      await showMessageDialog(
        barrierDismissible: false,
        title: context.str.locationIsOffTitle,
        message: context.str.locationIsOffMessage,
        actions: [
          TextButton(
            onPressed: onOpenDeviceLocationSettings,
            child: Text(context.str.goToSettings),
          ),
        ],
      );
    }
  }

  Future<void> showLocationAccessDeniedDialog({
    required VoidCallback onOpenDeviceLocationSettings,
    required VoidCallback onRefresh,
  }) async {
    final BuildContext? context = _appRouter.navigatorKey.currentContext;
    if (context != null) {
      await showMessageDialog(
        barrierDismissible: false,
        title: context.str.locationAccessDeniedTitle,
        message: context.str.locationAccessDeniedMessage,
        actions: [
          TextButton(
            onPressed: onOpenDeviceLocationSettings,
            child: Text(context.str.goToSettings),
          ),
          TextButton(
            onPressed: onRefresh,
            child: Text(context.str.refresh),
          ),
        ],
      );
    }
  }

  Future<bool> askForConfirmation({
    required String title,
    required String message,
    String? confirmationButtonText,
  }) async =>
      await _showAlertDialog(
        ConfirmationDialogComponent(
          title: title,
          message: message,
          confirmationButtonText: confirmationButtonText,
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

  void closeDialogIfIsOpened() {
    final BuildContext? context = _appRouter.navigatorKey.currentContext;
    if (_isDialogOpened && context != null) {
      Navigator.of(context).pop();
      _isDialogOpened = false;
    }
  }

  Future<T?> showFullScreenDialog<T>(
    Widget dialog,
  ) async {
    final BuildContext? context = _appRouter.navigatorKey.currentContext;
    if (context == null) return null;
    _isDialogOpened = true;
    final T? response = await showDialog(
      context: context,
      barrierColor: Colors.transparent,
      barrierDismissible: false,
      builder: (_) => Dialog.fullscreen(
        child: dialog,
      ),
    );
    _isDialogOpened = false;
    return response;
  }

  Future<T?> _showAlertDialog<T>(
    Widget dialog, {
    bool barrierDismissible = true,
  }) async {
    final BuildContext? context = _appRouter.navigatorKey.currentContext;
    if (context == null) return null;
    _isDialogOpened = true;
    final T? response = await showGeneralDialog<T>(
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
    _isDialogOpened = false;
    return response;
  }
}
