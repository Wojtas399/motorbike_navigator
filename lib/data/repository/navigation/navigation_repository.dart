import '../../../entity/coordinates.dart';
import '../../../entity/navigation.dart';

abstract interface class NavigationRepository {
  Future<Navigation?> loadNavigationByStartAndEndLocations({
    required Coordinates startLocation,
    required Coordinates endLocation,
  });
}
