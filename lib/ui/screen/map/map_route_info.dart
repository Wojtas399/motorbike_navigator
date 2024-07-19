import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../component/gap.dart';
import '../../component/text.dart';
import '../../cubit/route/route_cubit.dart';
import '../../extensions/context_extensions.dart';
import '../../extensions/duration_extensions.dart';

class MapRouteInfo extends StatelessWidget {
  const MapRouteInfo({super.key});

  @override
  Widget build(BuildContext context) => const _BodyContainer(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _StartPlace(),
            GapVertical8(),
            _Destination(),
            GapVertical8(),
            _Distance(),
            GapVertical8(),
            _EstimatedDuration(),
            GapVertical32(),
            _StartNavigationButton(),
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

class _StartPlace extends StatelessWidget {
  const _StartPlace();

  @override
  Widget build(BuildContext context) {
    final String? startPlaceName = context.select(
      (RouteCubit cubit) => cubit.state.startPlaceSuggestion?.name,
    );

    return _ValueWithLabel(
      label: context.str.routeInfoStartPlace,
      value: '$startPlaceName',
    );
  }
}

class _Destination extends StatelessWidget {
  const _Destination();

  @override
  Widget build(BuildContext context) {
    final String? destinationName = context.select(
      (RouteCubit cubit) => cubit.state.destinationSuggestion?.name,
    );

    return _ValueWithLabel(
      label: context.str.routeInfoDestination,
      value: '$destinationName',
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
      value: '${distanceInKm.toStringAsFixed(2)} km',
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
  Widget build(BuildContext context) => SizedBox(
        width: double.infinity,
        child: FilledButton.icon(
          onPressed: () {
            //TODO
          },
          icon: const Icon(Icons.navigation),
          label: Text(context.str.routeInfoNavigate),
        ),
      );
}
