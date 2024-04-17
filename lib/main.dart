import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:mapbox_search/mapbox_search.dart';

import 'app.dart';
import 'dependency_injection.dart';
import 'env.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
  MapboxOptions.setAccessToken(Env.mapboxAccessToken);
  MapBoxSearch.init(Env.mapboxAccessToken);
  runApp(const App());
}
