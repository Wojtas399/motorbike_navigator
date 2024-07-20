import '../../dependency_injection.dart';
import '../config/app_units.dart';

extension DoubleExtensions on double {
  String toDistanceFormat() {
    final String distanceStr = toStringAsFixed(2);
    final String unit = getIt.get<AppUnits>().distanceUnit;
    return '$distanceStr $unit';
  }

  String toSpeedFormat() {
    final String speedStr = toStringAsFixed(2);
    final String unit = getIt.get<AppUnits>().speedUnit;
    return '$speedStr $unit';
  }
}
