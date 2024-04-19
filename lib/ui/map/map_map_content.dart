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
  PointAnnotationManager? _pointAnnotationManager;
  PointAnnotation? _selectedPlacePointAnnotation;

  _onMapCreated(MapboxMap mapboxMap, Coordinates? currentLocation) async {
    mapboxMap.loadStyleURI(Env.mapboxStyleUri);
    final pointAnnotationManager =
        await mapboxMap.annotations.createPointAnnotationManager();
    setState(() {
      _pointAnnotationManager = pointAnnotationManager;
    });
    if (currentLocation != null) {
      final ByteData bytes = await rootBundle.load('assets/location_icon.png');
      await _setMarker(bytes, currentLocation);
    }
  }

  Future<void> _onSelectedPlaceChanged(Place? place) async {
    if (place != null && _selectedPlacePointAnnotation == null) {
      final ByteData bytes = await rootBundle.load('assets/pin.png');
      final pointAnnotation = await _setMarker(bytes, place.coordinates);
      setState(() {
        _selectedPlacePointAnnotation = pointAnnotation;
      });
    } else if (place == null && _selectedPlacePointAnnotation != null) {
      await _pointAnnotationManager?.delete(_selectedPlacePointAnnotation!);
      setState(() {
        _selectedPlacePointAnnotation = null;
      });
    }
  }

  Future<PointAnnotation?> _setMarker(
    ByteData markerByteData,
    Coordinates coordinates,
  ) async =>
      await _pointAnnotationManager?.create(
        PointAnnotationOptions(
          geometry: Point(
            coordinates: Position(
              coordinates.longitude,
              coordinates.latitude,
            ),
          ).toJson(),
          image: markerByteData.buffer.asUint8List(),
        ),
      );

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
