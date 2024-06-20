import '../../entity/coordinates.dart';
import '../../entity/route.dart';
import '../dto/route_dto.dart';

Route mapRouteFromDto(RouteDto routeDto, String id) => Route(
      id: id,
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
