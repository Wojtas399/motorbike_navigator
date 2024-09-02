import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/single_child_widget.dart';

import '../cubit/map_cubit.dart';
import '../cubit/map_state.dart';
import '../map_drive_details.dart';

class MapModeListener extends SingleChildStatefulWidget {
  const MapModeListener({super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends SingleChildState<MapModeListener> {
  bool _isBottomSheetOpened = false;

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
    if (_isBottomSheetOpened) {
      Navigator.pop(context);
      setState(() {
        _isBottomSheetOpened = false;
      });
    }
  }

  void _handleDriveMode() {
    setState(() {
      _isBottomSheetOpened = true;
    });
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      enableDrag: false,
      isDismissible: false,
      barrierColor: Colors.transparent,
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
