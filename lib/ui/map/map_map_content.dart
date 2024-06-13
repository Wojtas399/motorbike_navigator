import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../entity/coordinates.dart';
import '../../entity/place.dart';
import '../../env.dart';
import '../component/gap.dart';
import '../component/text.dart';
import '../extensions/context_extensions.dart';
import 'cubit/map_cubit.dart';
import 'cubit/map_state.dart';

class MapMapContent extends StatelessWidget {
  const MapMapContent({super.key});

  @override
  Widget build(BuildContext context) {
    final MapStatus cubitStatus = context.select(
      (MapCubit cubit) => cubit.state.status,
    );
    final Coordinates? currentLocation = context.select(
      (MapCubit cubit) => cubit.state.currentLocation,
    );
    final Place? selectedPlace = context.select(
      (MapCubit cubit) => cubit.state.selectedPlace,
    );
    final LatLng displayedPoint = LatLng(
      selectedPlace?.coordinates.latitude ??
          currentLocation?.latitude ??
          52.23178179122954,
      selectedPlace?.coordinates.longitude ??
          currentLocation?.longitude ??
          21.006002101026827,
    );

    return cubitStatus.isLoading
        ? const _LoadingContent()
        : FlutterMap(
            options: MapOptions(
              initialCenter: displayedPoint,
              keepAlive: true,
            ),
            children: [
              TileLayer(
                urlTemplate: Env.mapboxTemplateUrl,
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    width: selectedPlace != null ? 70 : 20,
                    height: selectedPlace != null ? 70 : 20,
                    point: displayedPoint,
                    child: Image.asset(
                      selectedPlace != null
                          ? 'assets/pin.png'
                          : 'assets/location_icon.png',
                    ),
                  ),
                ],
              ),
            ],
          );
  }
}

class _LoadingContent extends StatelessWidget {
  const _LoadingContent();

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TitleMedium(context.str.mapLoading),
            const GapVertical24(),
            const CircularProgressIndicator(),
          ],
        ),
      );
}
