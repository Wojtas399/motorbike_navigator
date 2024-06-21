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
      duration: const Duration(milliseconds: 500),
    );
    _positionAnimation = Tween<double>(begin: 0, end: 400).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInCubic,
      ),
    );
    super.initState();
  }

  void _onClose() {
    // _animationController.forward().whenComplete(
    //       context.read<MapCubit>().resetSelectedPlace,
    //     );
  }

  @override
  Widget build(BuildContext context) {
    final MapStateNavigation? navigation = context.select(
      (MapCubit cubit) => cubit.state.navigation,
    );

    return AnimatedBuilder(
      animation: _animationController,
      builder: (_, __) => Transform.translate(
        offset: Offset(0, _positionAnimation.value),
        child: Container(
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _RouteForm(),
              const GapVertical24(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: _onClose,
                      child: Text(context.str.close),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
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
