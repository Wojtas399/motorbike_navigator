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
import 'ui/cubit/location/location_cubit.dart';
import 'ui/provider/map_tile_url_provider.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => getIt.get<MapTileUrlProvider>()..initialize(),
          ),
          BlocProvider(
            create: (_) => getIt.get<LocationCubit>()..listenToLocationStatus(),
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
    const settings.ThemeMode? themeMode = settings.ThemeMode.light; //TODO

    return MaterialApp.router(
      routerConfig: getIt<AppRouter>().config(
        navigatorObservers: () => [
          RouteLocationObserver(),
        ],
      ),
      title: 'Motorbike navigator',
      themeMode: ThemeMode.light,
      // themeMode != null //TODO
      //     ? switch (themeMode) {
      //         user.ThemeMode.light => ThemeMode.light,
      //         user.ThemeMode.dark => ThemeMode.dark,
      //       }
      //     : null,
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
