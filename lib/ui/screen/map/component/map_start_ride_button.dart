import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../component/big_filled_button_with_icon.dart';
import '../../../cubit/drive/drive_cubit.dart';
import '../../../cubit/map/map_cubit.dart';
import '../../../cubit/map/map_state.dart';
import '../../../extensions/context_extensions.dart';

class MapStartRideButton extends StatelessWidget {
  const MapStartRideButton({super.key});

  void _onPressed(BuildContext context) {
    final mapCubit = context.read<MapCubit>();
    final userPosition = context.read<MapCubit>().state.userPosition;
    context.read<DriveCubit>().startDrive(startPosition: userPosition);
    mapCubit.followUserLocation();
    mapCubit.changeMode(MapMode.drive);
  }

  @override
  Widget build(BuildContext context) => BigFilledButtonWithIcon(
        onPressed: () => _onPressed(context),
        icon: Icons.navigation,
        label: context.str.mapStartNavigation,
      );
}
