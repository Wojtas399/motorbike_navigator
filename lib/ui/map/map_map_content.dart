import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import '../../entity/coordinates.dart';
import '../../entity/place.dart';
import '../../env.dart';
import '../component/gap.dart';
import '../component/text.dart';
import '../extensions/context_extensions.dart';
import 'cubit/map_cubit.dart';
import 'cubit/map_state.dart';

class MapMapContent extends StatefulWidget {
  const MapMapContent({super.key});

  @override
  State createState() => _MapState();
}

class _MapState extends State<MapMapContent> {
  MapboxMap? mapboxMap;

  _onMapCreated(MapboxMap mapboxMap, Coordinates? currentLocation) async {
    mapboxMap.loadStyleURI(Env.mapboxStyleUri);
    mapboxMap.annotations.createPointAnnotationManager().then(
      (pointAnnotationManager) async {
        if (currentLocation != null) {
          final ByteData bytes = await rootBundle.load(
            'assets/location_icon.png',
          );
          _setMarker(pointAnnotationManager, bytes, currentLocation);
        }
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
          _setMarker(pointAnnotationManager, bytes, place.coordinates);
        },
      );
    }
  }

  void _setMarker(
    PointAnnotationManager pointAnnotationManager,
    ByteData markerByteData,
    Coordinates coordinates,
  ) {
    final Uint8List list = markerByteData.buffer.asUint8List();
    var options = <PointAnnotationOptions>[];
    options.add(
      PointAnnotationOptions(
        geometry: Point(
          coordinates: Position(
            coordinates.longitude,
            coordinates.latitude,
          ),
        ).toJson(),
        image: list,
      ),
    );
    pointAnnotationManager.createMulti(options);
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
