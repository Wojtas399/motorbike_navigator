import '../../entity/coordinates.dart';
import '../../entity/navigation.dart';
import '../dto/navigation_dto.dart';
import 'route_mapper.dart';

Navigation mapNavigationFromDto({
  required Coordinates startLocation,
  required Coordinates endLocation,
  required NavigationDto dto,
}) =>
    Navigation(
      startLocation: startLocation,
      endLocation: endLocation,
      routes: dto.routes.map(mapRouteFromDto).toList(),
    );
