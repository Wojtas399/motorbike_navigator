import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'dependency_injection.dart';
import 'entity/settings.dart' as settings;
import 'location_status_listener.dart';
import 'route_location_observer.dart';
import 'ui/config/app_router.dart';
import 'ui/config/app_theme.dart';
import 'ui/cubit/drive/drive_cubit.dart';
import 'ui/cubit/location/location_cubit.dart';
import 'ui/cubit/settings/settings_cubit.dart';
import 'ui/provider/map_tile_url_provider.dart';
import 'ui/screen/map/cubit/map_cubit.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) => const _GlobalProviders(
        child: _MaterialApp(),
      );
}

class _GlobalProviders extends StatelessWidget {
  final Widget child;

  const _GlobalProviders({required this.child});

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => getIt.get<SettingsCubit>()..initialize(),
          ),
          BlocProvider(
            create: (_) => getIt.get<MapTileUrlProvider>()..initialize(),
          ),
          BlocProvider(
            create: (_) => getIt.get<LocationCubit>()..listenToLocationStatus(),
          ),
          BlocProvider(
            create: (_) => getIt.get<MapCubit>()..initialize(),
          ),
          BlocProvider(
            create: (_) => getIt.get<DriveCubit>(),
          ),
        ],
        child: child,
      );
}

class _MaterialApp extends StatelessWidget {
  const _MaterialApp();

  @override
  Widget build(BuildContext context) {
    final appTheme = getIt.get<AppTheme>();
    final settings.ThemeMode? themeMode = context.select(
      (SettingsCubit cubit) => cubit.state?.themeMode,
    );

    return MaterialApp.router(
      routerConfig: getIt<AppRouter>().config(
        navigatorObservers: () => [
          RouteLocationObserver(),
        ],
      ),
      title: 'Motorbike navigator',
      themeMode: themeMode != null
          ? switch (themeMode) {
              settings.ThemeMode.light => ThemeMode.light,
              settings.ThemeMode.dark => ThemeMode.dark,
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
      builder: (_, child) => LocationStatusListener(child: child),
    );
  }
}
