import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../entity/user.dart' as user;
import '../../config/app_router.dart';
import '../../cubit/logged_user/logged_user_cubit.dart';
import '../../extensions/context_extensions.dart';

class MapDrawer extends StatelessWidget {
  const MapDrawer({super.key});

  void _navigateToSavedDrives(BuildContext context) {
    context.pushRoute(const SavedDrivesRoute());
  }

  @override
  Widget build(BuildContext context) => Drawer(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Column(
              children: [
                ListTile(
                  title: Text(context.str.mapSavedDrives),
                  leading: const Icon(Icons.bookmark_outline),
                  onTap: () => _navigateToSavedDrives(context),
                ),
                ListTile(
                  title: Text(context.str.darkMode),
                  leading: const Icon(Icons.dark_mode),
                  trailing: const _DarkModeSwitch(),
                  onTap: () => _navigateToSavedDrives(context),
                ),
              ],
            ),
          ),
        ),
      );
}

class _DarkModeSwitch extends StatelessWidget {
  const _DarkModeSwitch();

  void _onChanged(bool isChecked, BuildContext context) {
    context.read<LoggedUserCubit>().changeThemeMode(
          isChecked ? user.ThemeMode.dark : user.ThemeMode.light,
        );
  }

  @override
  Widget build(BuildContext context) {
    final user.ThemeMode? themeMode = context.select(
      (LoggedUserCubit cubit) => cubit.state.themeMode,
    );

    return themeMode != null
        ? Switch(
            value: themeMode == user.ThemeMode.dark,
            onChanged: (bool isChecked) => _onChanged(isChecked, context),
          )
        : const CircularProgressIndicator();
  }
}
