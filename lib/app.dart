import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'dependency_injection.dart';
import 'entity/user.dart' as user;
import 'ui/config/app_router.dart';
import 'ui/config/app_theme.dart';
import 'ui/cubit/logged_user/logged_user_cubit.dart';
import 'ui/provider/map_tile_url_provider.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => getIt.get<LoggedUserCubit>()..initialize(),
          ),
          BlocProvider(
            create: (_) => getIt.get<MapTileUrlProvider>()..initialize(),
          ),
        ],
        child: const _MaterialApp(),
      );
}

class _MaterialApp extends StatelessWidget {
  const _MaterialApp();

  @override
  Widget build(BuildContext context) {
    final appTheme = getIt.get<AppTheme>();
    final user.ThemeMode? themeMode = context.select(
      (LoggedUserCubit cubit) => cubit.state.themeMode,
    );

    return MaterialApp.router(
      routerConfig: getIt<AppRouter>().config(),
      title: 'Motorbike navigator',
      themeMode: themeMode != null
          ? switch (themeMode) {
              user.ThemeMode.light => ThemeMode.light,
              user.ThemeMode.dark => ThemeMode.dark,
            }
          : null,
      theme: appTheme.lightTheme,
      darkTheme: appTheme.darkTheme,
      localizationsDelegates: const [
        Str.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('pl'),
      ],
    );
  }
}
