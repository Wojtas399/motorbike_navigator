import 'package:latlong2/latlong.dart';

import '../../entity/coordinates.dart';

extension CoordinatesExtensions on Coordinates {
  LatLng toLatLng() => LatLng(latitude, longitude);
}
