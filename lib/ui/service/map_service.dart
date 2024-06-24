import 'package:flutter_map_math/flutter_geo_math.dart';
import 'package:injectable/injectable.dart';

import '../../entity/coordinates.dart';

@injectable
class MapService {
  double calculateDistanceInMeters({
    required Coordinates location1,
    required Coordinates location2,
  }) {
    final mapMath = FlutterMapMath();
    return mapMath.distanceBetween(
      location1.latitude,
      location1.longitude,
      location2.latitude,
      location2.longitude,
      'meters',
    );
  }
}
