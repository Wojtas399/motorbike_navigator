import '../../dependency_injection.dart';
import '../config/app_units.dart';

extension DoubleExtensions on double {
  String toDistanceFormat() {
    final String unit = getIt.get<AppUnits>().distanceUnit;
    return '${_toUIFormat()} $unit';
  }

  String toSpeedFormat() {
    final String speedStr = toStringAsFixed(2);
    final String unit = getIt.get<AppUnits>().speedUnit;
    return '$speedStr $unit';
  }

  String _toUIFormat() => toStringAsFixed(2).replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]} ',
      );
}
