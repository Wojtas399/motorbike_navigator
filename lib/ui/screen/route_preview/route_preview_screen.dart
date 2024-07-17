import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';

import '../../../entity/coordinates.dart';
import '../../../entity/user.dart' as user;
import '../../component/map_component.dart';
import '../../cubit/logged_user/logged_user_cubit.dart';
import '../../extensions/coordinates_extensions.dart';

@RoutePage()
class RoutePreviewScreen extends StatelessWidget {
  final List<Coordinates> routeWaypoints;

  const RoutePreviewScreen({
    super.key,
    required this.routeWaypoints,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: const _CloseButton(),
      ),
      body: _Map(routeWaypoints: routeWaypoints),
    );
  }
}

class _CloseButton extends StatelessWidget {
  const _CloseButton();

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: IconButton.filled(
          onPressed: context.maybePop,
          icon: Icon(
            Icons.close,
            color: Theme.of(context).canvasColor,
          ),
        ),
      );
}

class _Map extends StatelessWidget {
  final List<Coordinates> routeWaypoints;

  const _Map({
    required this.routeWaypoints,
  });

  @override
  Widget build(BuildContext context) {
    final user.ThemeMode? themeMode = context.select(
      (LoggedUserCubit cubit) => cubit.state.themeMode,
    );
    CameraFit? initialCameraFit;
    if (routeWaypoints.toSet().length >= 2) {
      initialCameraFit = CameraFit.coordinates(
        coordinates: routeWaypoints
            .map((Coordinates waypoint) => waypoint.toLatLng())
            .toList(),
        padding: const EdgeInsets.all(64),
      );
    }

    return MapComponent(
      isDarkMode: themeMode == user.ThemeMode.dark,
      initialCenter: routeWaypoints.first,
      initialCameraFit: initialCameraFit,
      routeWaypoints: routeWaypoints,
    );
  }
}
