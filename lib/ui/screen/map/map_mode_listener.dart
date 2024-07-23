import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/single_child_widget.dart';

import 'cubit/map_cubit.dart';
import 'cubit/map_state.dart';
import 'map_drive_details.dart';

class MapModeListener extends SingleChildStatefulWidget {
  const MapModeListener({super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends SingleChildState<MapModeListener> {
  PersistentBottomSheetController? _bottomSheetController;

  Future<void> _onModeChanged(MapState state) async {
    switch (state.mode) {
      case MapMode.basic:
        _handleBasicMode();
      case MapMode.drive:
        _handleDriveMode();
      case _:
    }
  }

  void _handleBasicMode() {
    _bottomSheetController?.close();
    _bottomSheetController = null;
  }

  void _handleDriveMode() {
    _bottomSheetController?.close();
    _bottomSheetController = showBottomSheet(
      context: context,
      enableDrag: false,
      builder: (_) => const MapDriveDetails(),
    );
  }

  @override
  Widget buildWithChild(BuildContext context, Widget? child) =>
      BlocListener<MapCubit, MapState>(
        listenWhen: (MapState prevState, MapState currState) =>
            prevState.mode != currState.mode,
        listener: (_, MapState state) => _onModeChanged(state),
        child: child,
      );
}
