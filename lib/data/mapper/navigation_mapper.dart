import '../../entity/navigation.dart';
import '../dto/navigation_dto.dart';
import 'route_mapper.dart';

Navigation mapNavigationFromDto(NavigationDto dto) => Navigation(
      id: dto.id,
      routes: dto.routes.map(mapRouteFromDto).toList(),
    );
