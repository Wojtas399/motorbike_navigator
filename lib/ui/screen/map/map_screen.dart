import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../dependency_injection.dart';
import '../../cubit/drive/drive_cubit.dart';
import '../../cubit/drive/drive_state.dart';
import '../../cubit/logged_user/logged_user_cubit.dart';
import '../drive_summary/drive_summary_screen.dart';
import 'cubit/map_cubit.dart';
import 'map_content.dart';
import 'map_drawer.dart';

@RoutePage()
class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => getIt.get<LoggedUserCubit>()..initialize(),
          ),
          BlocProvider(
            create: (_) => getIt.get<MapCubit>()..initialize(),
          ),
          BlocProvider(
            create: (_) => getIt.get<DriveCubit>(),
          ),
        ],
        child: const _DriveCubitListener(
          child: Scaffold(
            drawer: MapDrawer(),
            body: Stack(
              children: [
                MapContent(),
                Positioned(
                  left: 16,
                  top: kToolbarHeight + 24,
                  child: _MenuButton(),
                ),
              ],
            ),
          ),
        ),
      );
}

class _DriveCubitListener extends StatelessWidget {
  final Widget child;

  const _DriveCubitListener({required this.child});

  void _onStatusChanged(DriveStateStatus status, BuildContext context) {
    if (status == DriveStateStatus.paused) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: context.read<DriveCubit>(),
            child: const DriveSummaryScreen(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) => BlocListener<DriveCubit, DriveState>(
        listenWhen: (prevState, currState) =>
            prevState.status != currState.status,
        listener: (context, state) => _onStatusChanged(state.status, context),
        child: child,
      );
}

class _MenuButton extends StatelessWidget {
  const _MenuButton();

  void _onPressed(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  @override
  Widget build(BuildContext context) => IconButton.filled(
        onPressed: () => _onPressed(context),
        icon: const Icon(Icons.menu),
      );
}
