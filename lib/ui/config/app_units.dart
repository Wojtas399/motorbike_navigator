import 'package:injectable/injectable.dart';

@injectable
class AppUnits {
  String get distance => 'km';

  String get speed => 'km/h';

  String get elevation => 'm n.p.m';
}
