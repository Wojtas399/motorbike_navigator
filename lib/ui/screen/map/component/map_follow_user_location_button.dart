import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../cubit/map/map_cubit.dart';
import '../../../cubit/map/map_state.dart';

class MapFollowUserLocationButton extends StatelessWidget {
  const MapFollowUserLocationButton({super.key});

  void _onPressed(BuildContext context) {
    context.read<MapCubit>().followUserLocation();
  }

  @override
  Widget build(BuildContext context) {
    final MapFocusMode focusMode = context.select(
      (MapCubit cubit) => cubit.state.focusMode,
    );

    return FloatingActionButton(
      heroTag: null,
      onPressed: () => _onPressed(context),
      child: Icon(
        focusMode == MapFocusMode.followUserLocation
            ? Icons.near_me
            : Icons.near_me_outlined,
      ),
    );
  }
}
