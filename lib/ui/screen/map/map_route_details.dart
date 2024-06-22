import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../component/gap.dart';
import '../../component/route_form_component.dart';
import '../../extensions/context_extensions.dart';
import 'cubit/map_cubit.dart';
import 'cubit/map_state.dart';

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
      duration: const Duration(milliseconds: 250),
    );
    _positionAnimation = Tween<double>(begin: -350, end: 0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInCubic,
      ),
    );
    _animationController.forward();
    super.initState();
  }

  Future<void> _onSubmit() async {
    // await context.read<MapCubit>().loadNavigation();
  }

  void _onClose() {
    _animationController.reverse().whenComplete(
          context.read<MapCubit>().closeRouteSelection,
        );
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _animationController,
        builder: (_, __) => Transform.translate(
          offset: Offset(0, _positionAnimation.value),
          child: _BodyContainer(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _RouteForm(),
                const GapVertical24(),
                _Buttons(
                  onSubmitButtonPressed: _onSubmit,
                  onCloseButtonPressed: _onClose,
                ),
              ],
            ),
          ),
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
        padding: const EdgeInsets.fromLTRB(24, kToolbarHeight + 32, 16, 24),
        decoration: BoxDecoration(
          color: context.colorScheme.surface,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(32),
            bottomRight: Radius.circular(32),
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

class _RouteForm extends StatelessWidget {
  const _RouteForm();

  Future<void> _onStartPlaceTap(BuildContext context) async {
    //TODO: Should open search form
  }

  Future<void> _onDestinationPlaceTap(BuildContext context) async {
    //TODO: Should open search form
  }

  Future<void> _onSwapLocationsTap(BuildContext context) async {
    //TODO: Should swap locations
  }

  @override
  Widget build(BuildContext context) {
    final MapStateNavigation? navigation = context.select(
      (MapCubit cubit) => cubit.state.navigation,
    );

    return RouteFormComponent(
      initialStartPlaceValue: navigation?.startPlace.name,
      initialDestinationValue: navigation?.destination.name,
      onStartPlaceTap: () => _onStartPlaceTap(context),
      onDestinationTap: () => _onDestinationPlaceTap(context),
      onSwapLocationsTap: () => _onSwapLocationsTap(context),
    );
  }
}

class _Buttons extends StatelessWidget {
  final VoidCallback onSubmitButtonPressed;
  final VoidCallback onCloseButtonPressed;

  const _Buttons({
    required this.onSubmitButtonPressed,
    required this.onCloseButtonPressed,
  });

  @override
  Widget build(BuildContext context) => SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            SizedBox(
              width: 300,
              child: FilledButton(
                onPressed: onSubmitButtonPressed,
                child: const Text('Szukaj trasy'),
              ),
            ),
            SizedBox(
              width: 300,
              child: TextButton(
                onPressed: onCloseButtonPressed,
                child: Text(context.str.close),
              ),
            ),
          ],
        ),
      );
}
