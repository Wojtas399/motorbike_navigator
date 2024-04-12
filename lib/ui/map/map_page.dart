import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:motorbike_navigator/ui/component/gap.dart';

import '../../env.dart';
import '../../location_provider.dart';
import '../../location_service.dart';
import '../component/text.dart';

class MapPage extends ConsumerStatefulWidget {
  const MapPage({super.key});

  @override
  ConsumerState createState() => FullMapState();
}

class FullMapState extends ConsumerState<MapPage> {
  MapboxMap? mapboxMap;

  _onMapCreated(MapboxMap mapboxMap, MapPosition? currentPosition) async {
    mapboxMap.loadStyleURI(Env.mapboxStyleUri);
    mapboxMap.annotations.createPointAnnotationManager().then(
      (pointAnnotationManager) async {
        final ByteData bytes = await rootBundle.load('assets/custom-icon.png');
        final Uint8List list = bytes.buffer.asUint8List();
        var options = <PointAnnotationOptions>[];
        if (currentPosition != null) {
          options.add(
            PointAnnotationOptions(
              geometry: Point(
                coordinates: Position(
                  currentPosition.longitude,
                  currentPosition.latitude,
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

  @override
  Widget build(BuildContext context) {
    final currentPositionAsyncVal = ref.watch(locationProvider);

    return currentPositionAsyncVal.isLoading
        ? const _LoadingContent()
        : Scaffold(
            body: MapWidget(
              key: ValueKey("mapWidget"),
              onMapCreated: (mapbox) =>
                  _onMapCreated(mapbox, currentPositionAsyncVal.value),
              cameraOptions: currentPositionAsyncVal.value != null
                  ? CameraOptions(
                      center: Point(
                        coordinates: Position(
                          currentPositionAsyncVal.value!.longitude,
                          currentPositionAsyncVal.value!.latitude,
                        ),
                      ).toJson(),
                      zoom: 14.0,
                    )
                  : null,
            ),
          );
  }
}

class _LoadingContent extends StatelessWidget {
  const _LoadingContent();

  @override
  Widget build(BuildContext context) => const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TitleMedium('Ładowanie mapy...'),
            GapVertical24(),
            CircularProgressIndicator()
          ],
        ),
      );
}
