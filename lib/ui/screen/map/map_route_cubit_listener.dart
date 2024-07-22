import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/single_child_widget.dart';

import '../../../dependency_injection.dart';
import '../../cubit/route/route_cubit.dart';
import '../../cubit/route/route_state.dart';
import '../../extensions/context_extensions.dart';
import '../../service/dialog_service.dart';
import 'cubit/map_cubit.dart';
import 'cubit/map_state.dart';

class MapRouteCubitListener extends SingleChildStatelessWidget {
  const MapRouteCubitListener({super.key});

  void _onStatusChanged(RouteStateStatus status, BuildContext context) {
    switch (status) {
      case RouteStateStatus.pointsMustBeDifferent:
        _handlePointsMustBeDifferentStatus(context);
      case RouteStateStatus.routeFound:
        _handleRouteFoundStatus(context);
      case RouteStateStatus.routeNotFound:
        _handleRouteNotFoundStatus(context);
      case _:
    }
  }

  void _handlePointsMustBeDifferentStatus(BuildContext context) {
    getIt.get<DialogService>().showMessageDialog(
          title: context.str.routeFormTheSameStartAndEndPointsTitle,
          message: context.str.routeFormTheSameStartAndEndPointsMessage,
        );
  }

  void _handleRouteFoundStatus(BuildContext context) {
    context.read<MapCubit>().changeMode(MapMode.routePreview);
  }

  void _handleRouteNotFoundStatus(BuildContext context) {
    getIt.get<DialogService>().showMessageDialog(
          title: context.str.routeFormNoRouteFoundTitle,
          message: context.str.routeFormNoRouteFoundMessage,
        );
  }

  @override
  Widget buildWithChild(BuildContext context, Widget? child) =>
      BlocListener<RouteCubit, RouteState>(
        listenWhen: (RouteState prevState, RouteState currState) =>
            prevState.status != currState.status,
        listener: (BuildContext context, RouteState state) =>
            _onStatusChanged(state.status, context),
        child: child,
      );
}
