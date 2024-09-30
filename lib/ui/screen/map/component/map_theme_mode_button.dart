import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../entity/settings.dart' as settings;
import '../../../cubit/settings/settings_cubit.dart';

class MapThemeModeButton extends StatelessWidget {
  const MapThemeModeButton({super.key});

  @override
  Widget build(BuildContext context) {
    final settings.ThemeMode? themeMode = context.select(
      (SettingsCubit cubit) => cubit.state?.themeMode,
    );

    return themeMode != null
        ? IconButton.filledTonal(
            icon: switch (themeMode) {
              settings.ThemeMode.light => const Icon(Icons.dark_mode),
              settings.ThemeMode.dark => const Icon(Icons.light_mode),
            },
            onPressed: context.read<SettingsCubit>().switchThemeMode,
          )
        : const CircularProgressIndicator();
  }
}
