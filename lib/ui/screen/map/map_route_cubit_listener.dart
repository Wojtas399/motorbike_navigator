import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/single_child_widget.dart';

import '../../../dependency_injection.dart';
import '../../cubit/route/route_cubit.dart';
import '../../cubit/route/route_state.dart';
import '../../extensions/context_extensions.dart';
import '../../service/dialog_service.dart';
import 'cubit/map_cubit.dart';
import 'map_route_info.dart';

class MapRouteCubitListener extends SingleChildStatelessWidget {
  const MapRouteCubitListener({super.key});

  void _onStatusChanged(RouteStateStatus status, BuildContext context) {
    switch (status) {
      case RouteStateStatus.routeFound:
        _handleRouteFoundStatus(context);
      case RouteStateStatus.routeNotFound:
        _handleRouteNotFoundStatus(context);
      case _:
    }
  }

  void _handleRouteFoundStatus(BuildContext context) {
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
  }

  Future<void> _handleRouteNotFoundStatus(BuildContext context) async {
    await getIt.get<DialogService>().showMessageDialog(
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
