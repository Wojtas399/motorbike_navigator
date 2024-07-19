import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/single_child_widget.dart';

import '../../../dependency_injection.dart';
import '../../cubit/drive/drive_cubit.dart';
import '../../cubit/drive/drive_state.dart';
import '../../cubit/route/route_cubit.dart';
import '../../cubit/route/route_state.dart';
import '../../extensions/context_extensions.dart';
import '../../service/dialog_service.dart';
import '../drive_summary/drive_summary_screen.dart';
import 'cubit/map_cubit.dart';
import 'map_content.dart';
import 'map_drawer.dart';
import 'map_route_info.dart';

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
          BlocProvider(
            create: (_) => getIt.get<RouteCubit>(),
          ),
        ],
        child: const _Content(),
      );
}

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    final DriveStateStatus driveStatus = context.select(
      (DriveCubit cubit) => cubit.state.status,
    );

    return Scaffold(
      drawer: driveStatus.isInitial ? const MapDrawer() : null,
      body: MultiBlocListener(
        listeners: const [
          _DriveCubitListener(),
          _RouteCubitListener(),
        ],
        child: Stack(
          children: [
            const MapContent(),
            if (driveStatus.isInitial)
              const Positioned(
                left: 16,
                top: kToolbarHeight + 24,
                child: _MenuButton(),
              ),
          ],
        ),
      ),
    );
  }
}

class _DriveCubitListener extends SingleChildStatelessWidget {
  const _DriveCubitListener();

  void _onStatusChanged(DriveStateStatus status, BuildContext context) {
    if (status == DriveStateStatus.paused) {
      _navigateToDriveSummary(context);
    }
  }

  void _navigateToDriveSummary(BuildContext context) {
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

  @override
  Widget buildWithChild(BuildContext context, Widget? child) =>
      BlocListener<DriveCubit, DriveState>(
        listenWhen: (prevState, currState) =>
            prevState.status != currState.status,
        listener: (context, state) => _onStatusChanged(state.status, context),
        child: child,
      );
}

class _RouteCubitListener extends SingleChildStatelessWidget {
  const _RouteCubitListener();

  Future<void> _onStatusChanged(
    RouteStateStatus status,
    BuildContext context,
  ) async {
    if (status == RouteStateStatus.routeFound) {
      showBottomSheet(
        context: context,
        enableDrag: false,
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider.value(
              value: context.read<RouteCubit>(),
            ),
            BlocProvider.value(
              value: context.read<MapCubit>(),
            ),
          ],
          child: const MapRouteInfo(),
        ),
      );
    } else if (status == RouteStateStatus.routeNotFound) {
      await getIt.get<DialogService>().showMessageDialog(
            title: context.str.routeFormNoRouteFoundTitle,
            message: context.str.routeFormNoRouteFoundMessage,
          );
    }
  }

  @override
  Widget buildWithChild(BuildContext context, Widget? child) =>
      BlocListener<RouteCubit, RouteState>(
        listenWhen: (
          RouteState prevState,
          RouteState currState,
        ) =>
            prevState.status != currState.status,
        listener: (_, RouteState state) =>
            _onStatusChanged(state.status, context),
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
