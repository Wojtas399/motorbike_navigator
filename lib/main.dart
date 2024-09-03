import 'package:flutter/material.dart';
import 'package:mapbox_search/mapbox_search.dart';

import 'app.dart';
import 'dependency_injection.dart';
import 'env.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
  MapBoxSearch.init(Env.mapboxAccessToken);
  runApp(const App());
}
