import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:motorbike_navigator/ui/component/gap.dart';
import 'package:motorbike_navigator/ui/extensions/context_extensions.dart';
import 'package:motorbike_navigator/ui/map/map_search_bar.dart';
import 'package:motorbike_navigator/ui/map/map_search_content.dart';

import '../../env.dart';
import '../../location_provider.dart';
import '../../location_service.dart';
import '../component/text.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<StatefulWidget> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  bool _isSearchMode = false;

  void _onSearchBarTap() {
    setState(() {
      _isSearchMode = true;
    });
  }

  void _onSearchModeClose() {
    setState(() {
      _isSearchMode = false;
    });
  }

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          _isSearchMode ? const MapSearchContent() : const _Map(),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
            child: MapSearchBar(
              isInSearchMode: _isSearchMode,
              onTap: _onSearchBarTap,
              onBackButtonPressed: _onSearchModeClose,
            ),
          ),
        ],
      );
}

class _Map extends ConsumerStatefulWidget {
  const _Map();

  @override
  ConsumerState createState() => _MapState();
}

class _MapState extends ConsumerState<_Map> {
  MapboxMap? mapboxMap;

  _onMapCreated(MapboxMap mapboxMap, MapPosition? currentPosition) async {
    mapboxMap.loadStyleURI(Env.mapboxStyleUri);
    mapboxMap.annotations.createPointAnnotationManager().then(
      (pointAnnotationManager) async {
        final ByteData bytes = await rootBundle.load(
          'assets/location_icon.png',
        );
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
    this.mapboxMap = mapboxMap;
  }

  @override
  Widget build(BuildContext context) {
    final currentPositionAsyncVal = ref.watch(locationProvider);

    return currentPositionAsyncVal.isLoading
        ? const _LoadingContent()
        : Scaffold(
            body: MapWidget(
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
