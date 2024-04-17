import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import '../../dependency_injection.dart';
import '../../entity/coordinates.dart';
import '../../entity/place.dart';
import '../../env.dart';
import '../component/gap.dart';
import '../component/text.dart';
import '../extensions/context_extensions.dart';
import 'cubit/map_cubit.dart';
import 'cubit/map_state.dart';
import 'map_search_bar.dart';
import 'map_search_content.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (_) => getIt.get<MapCubit>()..initialize(),
        child: const _Content(),
      );
}

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    final MapMode mapMode = context.select(
      (MapCubit cubit) => cubit.state.mode,
    );

    return Stack(
      children: [
        switch (mapMode) {
          MapMode.map => const _Map(),
          MapMode.search => const MapSearchContent(),
        },
        const Padding(
          padding: EdgeInsets.fromLTRB(24, 24, 24, 0),
          child: MapSearchBar(),
        ),
      ],
    );
  }
}

class _Map extends StatefulWidget {
  const _Map();

  @override
  State createState() => _MapState();
}

class _MapState extends State<_Map> {
  MapboxMap? mapboxMap;

  _onMapCreated(MapboxMap mapboxMap, Coordinates? currentLocation) async {
    mapboxMap.loadStyleURI(Env.mapboxStyleUri);
    mapboxMap.annotations.createPointAnnotationManager().then(
      (pointAnnotationManager) async {
        final ByteData bytes = await rootBundle.load(
          'assets/location_icon.png',
        );
        final Uint8List list = bytes.buffer.asUint8List();
        var options = <PointAnnotationOptions>[];
        if (currentLocation != null) {
          options.add(
            PointAnnotationOptions(
              geometry: Point(
                coordinates: Position(
                  currentLocation.longitude,
                  currentLocation.latitude,
                ),
              ).toJson(),
              image: list,
            ),
          );
        }
        pointAnnotationManager.createMulti(options);
      },
    );
    setState(() {
      this.mapboxMap = mapboxMap;
    });
  }

  void _onSelectedPlaceChanged(Place? place) {
    if (mapboxMap != null && place != null) {
      mapboxMap!.annotations.createPointAnnotationManager().then(
        (pointAnnotationManager) async {
          final ByteData bytes = await rootBundle.load('assets/pin.png');
          final Uint8List list = bytes.buffer.asUint8List();
          var options = <PointAnnotationOptions>[];
          options.add(
            PointAnnotationOptions(
              geometry: Point(
                coordinates: Position(
                  place.coordinates.longitude,
                  place.coordinates.latitude,
                ),
              ).toJson(),
              image: list,
            ),
          );
          pointAnnotationManager.createMulti(options);
        },
      );
    }
  }

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
    _onSelectedPlaceChanged(selectedPlace);

    return cubitStatus.isInitial || cubitStatus.isLoading
        ? const _LoadingContent()
        : Scaffold(
            body: MapWidget(
              onMapCreated: (mapbox) => _onMapCreated(mapbox, currentLocation),
              cameraOptions: CameraOptions(
                center: selectedPlace != null || currentLocation != null
                    ? Point(
                        coordinates: selectedPlace != null
                            ? Position(
                                selectedPlace.coordinates.longitude,
                                selectedPlace.coordinates.latitude,
                              )
                            : Position(
                                currentLocation!.longitude,
                                currentLocation.latitude,
                              ),
                      ).toJson()
                    : null,
                zoom: 14.0,
              ),
            ),
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
