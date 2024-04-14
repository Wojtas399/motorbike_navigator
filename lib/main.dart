import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:mapbox_search/mapbox_search.dart';
import 'package:motorbike_navigator/app.dart';
import 'package:motorbike_navigator/env.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MapboxOptions.setAccessToken(Env.mapboxAccessToken);
  MapBoxSearch.init(Env.mapboxAccessToken);
  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}
