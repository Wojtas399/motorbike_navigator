import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:motorbike_navigator/env.dart';
import 'package:motorbike_navigator/location_provider.dart';

import 'location_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MapboxOptions.setAccessToken(Env.mapboxAccessToken);
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const FullMap(),
    );
  }
}

class FullMap extends ConsumerStatefulWidget {
  const FullMap();

  @override
  ConsumerState createState() => FullMapState();
}

class FullMapState extends ConsumerState<FullMap> {
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
        ? CircularProgressIndicator()
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
                      zoom: 12.0,
                    )
                  : null,
            ),
          );
  }
}

Point createRandomPoint() {
  return Point(
    coordinates: createRandomPosition(),
  );
}

Position createRandomPosition() {
  var random = Random();
  return Position(random.nextDouble() * -360.0 + 180.0,
      random.nextDouble() * -180.0 + 90.0);
}
