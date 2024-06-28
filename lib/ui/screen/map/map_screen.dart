import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../dependency_injection.dart';
import '../../cubit/drive/drive_cubit.dart';
import '../../cubit/drive/drive_state.dart';
import '../../cubit/map/map_cubit.dart';
import '../drive_summary/drive_summary_screen.dart';
import 'map_content.dart';

@RoutePage()
class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => getIt.get<MapCubit>()..initialize(),
          ),
          BlocProvider(
            create: (_) => getIt.get<DriveCubit>(),
          ),
        ],
        child: const _DriveCubitListener(
          child: MapContent(),
        ),
      );
}

class _DriveCubitListener extends StatelessWidget {
  final Widget child;

  const _DriveCubitListener({required this.child});

  void _onStatusChanged(DriveStateStatus status, BuildContext context) {
    if (status == DriveStateStatus.finished) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider.value(
                value: context.read<MapCubit>(),
              ),
              BlocProvider.value(
                value: context.read<DriveCubit>(),
              ),
            ],
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
