import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_search/mapbox_search.dart';

import 'app.dart';
import 'dependency_injection.dart';
import 'env.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  configureDependencies();
  MapBoxSearch.init(Env.mapboxAccessToken);
  runApp(const App());
}
