import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/map/map_cubit.dart';

class MapActionButtons extends StatelessWidget {
  const MapActionButtons({super.key});

  void _onMoveBackToUserLocation(BuildContext context) {
    // context.read<MapCubit>().moveBackToUserLocation();
  }

  Future<void> _onOpenRouteForm(BuildContext context) async {
    // context.read<MapCubit>().openRouteSelection();
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
