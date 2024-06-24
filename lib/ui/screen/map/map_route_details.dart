import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../component/gap.dart';
import '../../component/text.dart';
import '../../extensions/context_extensions.dart';
import '../route_form/cubit/route_form_cubit.dart';

class MapRouteDetails extends StatefulWidget {
  const MapRouteDetails({super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<MapRouteDetails>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _positionAnimation;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _positionAnimation = Tween<double>(begin: 400, end: 0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInCubic,
      ),
    );
    _animationController.forward();
    super.initState();
  }

  void _onStartNavigation() {
    //TODO
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _animationController,
        builder: (_, __) => Transform.translate(
          offset: Offset(0, _positionAnimation.value),
          child: _Body(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _RouteInfo(),
                const GapVertical16(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _StartNavigationButton(
                      onPressed: _onStartNavigation,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
}

class _Body extends StatelessWidget {
  final Widget child;

  const _Body({
    required this.child,
  });

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
        decoration: BoxDecoration(
          color: context.colorScheme.surface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              offset: const Offset(0, -2),
              blurRadius: 20,
            ),
          ],
        ),
        child: child,
      );
}

class _RouteInfo extends StatelessWidget {
  const _RouteInfo();

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Row(
            children: [
              LabelLarge(
                '${context.str.mapRouteDistance}: ',
                color: context.colorScheme.outline,
              ),
              const GapHorizontal4(),
              const _Distance(),
            ],
          ),
          const GapVertical8(),
          Row(
            children: [
              LabelLarge(
                '${context.str.mapRouteEstimatedDuration}: ',
                color: context.colorScheme.outline,
              ),
              const GapHorizontal4(),
              const _Duration(),
            ],
          ),
        ],
      );
}

class _Distance extends StatelessWidget {
  const _Distance();

  @override
  Widget build(BuildContext context) {
    final double? distanceInMeters = context.select(
      (RouteFormCubit cubit) => cubit.state.route?.distanceInMeters,
    );
    double? distanceInKm;
    if (distanceInMeters != null) {
      distanceInKm = distanceInMeters / 1000;
    }

    return TitleMedium('${distanceInKm?.toStringAsFixed(2)} km');
  }
}

class _Duration extends StatelessWidget {
  const _Duration();

  @override
  Widget build(BuildContext context) {
    final double? durationInSeconds = context.select(
      (RouteFormCubit cubit) => cubit.state.route?.durationInSeconds,
    );
    double? durationInMinutes;
    if (durationInSeconds != null) {
      durationInMinutes = durationInSeconds / 60;
    }

    return TitleMedium('${durationInMinutes?.toStringAsFixed(2)} min');
  }
}

class _StartNavigationButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _StartNavigationButton({
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) => SizedBox(
        width: 250,
        child: FilledButton.icon(
          onPressed: onPressed,
          icon: const Icon(Icons.navigation),
          label: Text(context.str.mapStartNavigation),
        ),
      );
}
