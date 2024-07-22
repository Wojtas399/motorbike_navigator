import 'package:injectable/injectable.dart';

import '../../entity/coordinates.dart';
import '../../entity/route_suggestions.dart';
import '../dto/route_dto.dart';
import 'mapper.dart';

@injectable
class RouteMapper extends Mapper<Route, RouteDto> {
  const RouteMapper();

  @override
  Route mapFromDto(RouteDto dto) => Route(
        duration: Duration(seconds: dto.durationInSeconds.toInt()),
        distanceInMeters: dto.distanceInMeters,
        waypoints: dto.geometry.coordinates
            .map(
              (coordinates) => Coordinates(
                coordinates.lat,
                coordinates.long,
              ),
            )
            .toList(),
      );
}
