import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../animation/fade_page_route_animation.dart';
import '../route_form/route_form_screen.dart';
import 'cubit/map_cubit.dart';

class MapActionButtons extends StatelessWidget {
  const MapActionButtons({super.key});

  void _onMoveBackToUserLocation(BuildContext context) {
    context.read<MapCubit>().moveBackToUserLocation();
  }

  Future<void> _onOpenRouteForm(BuildContext context) async {
    final RouteFormResult? route = await Navigator.of(context).push(
      FadePageRouteAnimation(
        page: const RouteFormScreen(),
      ),
    );
    if (route != null && context.mounted) {
      await context.read<MapCubit>().loadRouteWaypoints(
            startPlaceId: route.startPlaceId,
            destinationId: route.destinationId,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool doesUserLocationExist = context.select(
      (MapCubit cubit) => cubit.state.userLocation != null,
    );

    return Positioned(
      bottom: 24,
      right: 24,
      child: Column(
        children: [
          if (doesUserLocationExist) ...[
            FloatingActionButton(
              onPressed: () => _onMoveBackToUserLocation(context),
              heroTag: null,
              child: const Icon(Icons.my_location),
            ),
            const SizedBox(height: 24),
          ],
          FloatingActionButton(
            onPressed: () => _onOpenRouteForm(context),
            heroTag: null,
            child: const Icon(Icons.directions),
          ),
        ],
      ),
    );
  }
}
