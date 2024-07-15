import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'dependency_injection.dart';
import 'entity/user.dart' as user;
import 'ui/config/app_router.dart';
import 'ui/cubit/logged_user/logged_user_cubit.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (_) => getIt.get<LoggedUserCubit>()..initialize(),
        child: const _MaterialApp(),
      );
}

class _MaterialApp extends StatelessWidget {
  const _MaterialApp();

  @override
  Widget build(BuildContext context) {
    final user.ThemeMode? themeMode = context.select(
      (LoggedUserCubit cubit) => cubit.state.themeMode,
    );

    return MaterialApp.router(
      routerConfig: getIt<AppRouter>().config(
        navigatorObservers: () => [
          HeroController(),
        ],
      ),
      title: 'Motorbike navigator',
      themeMode: themeMode != null
          ? switch (themeMode) {
              user.ThemeMode.light => ThemeMode.light,
              user.ThemeMode.dark => ThemeMode.dark,
            }
          : null,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.dark,
        ),
      ),
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
