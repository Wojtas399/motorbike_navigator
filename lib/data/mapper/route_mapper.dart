import '../../entity/coordinates.dart';
import '../../entity/navigation.dart';
import '../dto/route_dto.dart';

Route mapRouteFromDto(RouteDto routeDto) => Route(
      distanceInMeters: routeDto.distanceInMeters,
      waypoints: routeDto.geometry.coordinates
          .map(
            (coordinates) => Coordinates(
              coordinates.lat,
              coordinates.long,
            ),
          )
          .toList(),
    );
