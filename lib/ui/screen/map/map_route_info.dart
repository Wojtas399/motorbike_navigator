import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../entity/map_point.dart';
import '../../component/gap.dart';
import '../../component/text.dart';
import '../../cubit/route/route_cubit.dart';
import '../../extensions/context_extensions.dart';
import '../../extensions/double_extensions.dart';
import '../../extensions/duration_extensions.dart';
import '../../extensions/map_point_extensions.dart';
import 'cubit/map_cubit.dart';
import 'cubit/map_state.dart';

class MapRouteInfo extends StatelessWidget {
  const MapRouteInfo({super.key});

  @override
  Widget build(BuildContext context) => const _BodyContainer(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _StartPoint(),
            GapVertical8(),
            _EndPoint(),
            GapVertical8(),
            _Distance(),
            GapVertical8(),
            _EstimatedDuration(),
            GapVertical32(),
            Row(
              children: [
                Expanded(
                  child: _CancelButton(),
                ),
                GapHorizontal16(),
                Expanded(
                  child: _StartNavigationButton(),
                ),
              ],
            ),
          ],
        ),
      );
}

class _BodyContainer extends StatelessWidget {
  final Widget child;

  const _BodyContainer({
    required this.child,
  });

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.fromLTRB(24, 32, 24, 64),
        decoration: BoxDecoration(
          color: context.colorScheme.surface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
        ),
        child: child,
      );
}

class _StartPoint extends StatelessWidget {
  const _StartPoint();

  @override
  Widget build(BuildContext context) {
    final MapPoint? startPoint = context.select(
      (RouteCubit cubit) => cubit.state.startPoint,
    );

    return _ValueWithLabel(
      label: context.str.routeInfoStartPlace,
      value: '${startPoint?.toUIName(context)}',
    );
  }
}

class _EndPoint extends StatelessWidget {
  const _EndPoint();

  @override
  Widget build(BuildContext context) {
    final MapPoint? endPoint = context.select(
      (RouteCubit cubit) => cubit.state.endPoint,
    );

    return _ValueWithLabel(
      label: context.str.routeInfoDestination,
      value: '${endPoint?.toUIName(context)}',
    );
  }
}

class _Distance extends StatelessWidget {
  const _Distance();

  @override
  Widget build(BuildContext context) {
    final double? distanceInMeters = context.select(
      (RouteCubit cubit) => cubit.state.route?.distanceInMeters,
    );
    final double distanceInKm = (distanceInMeters ?? 0) / 1000;

    return _ValueWithLabel(
      label: context.str.distance,
      value: distanceInKm.toDistanceFormat(),
    );
  }
}

class _EstimatedDuration extends StatelessWidget {
  const _EstimatedDuration();

  @override
  Widget build(BuildContext context) {
    final Duration? duration = context.select(
      (RouteCubit cubit) => cubit.state.route?.duration,
    );

    return _ValueWithLabel(
      label: context.str.routeInfoEstimatedDuration,
      value: '${duration?.toUIFormat()}',
    );
  }
}

class _ValueWithLabel extends StatelessWidget {
  final String label;
  final String value;

  const _ValueWithLabel({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BodyMedium('$label: '),
          Expanded(
            child: BodyMedium(
              value,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );
}

class _StartNavigationButton extends StatelessWidget {
  const _StartNavigationButton();

  @override
  Widget build(BuildContext context) => FilledButton.icon(
        onPressed: () {
          //TODO
        },
        icon: const Icon(Icons.navigation_outlined),
        label: Text(context.str.routeInfoNavigate),
      );
}

class _CancelButton extends StatelessWidget {
  const _CancelButton();

  void _onPressed(BuildContext context) {
    context.read<RouteCubit>().resetRoute();
    final mapCubit = context.read<MapCubit>();
    mapCubit.followUserLocation();
    mapCubit.changeMode(MapMode.selectingRoute);
  }

  @override
  Widget build(BuildContext context) => OutlinedButton.icon(
        onPressed: () => _onPressed(context),
        icon: const Icon(Icons.cancel_outlined),
        label: Text(context.str.cancel),
      );
}
