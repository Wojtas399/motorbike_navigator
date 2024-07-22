import 'package:collection/collection.dart';
import 'package:injectable/injectable.dart';

import '../../../entity/coordinates.dart';
import '../../../entity/route_suggestions.dart';
import '../../api_service/navigation_api_service.dart';
import '../../dto/navigation_dto.dart';
import '../../mapper/route_mapper.dart';
import '../repository.dart';
import 'route_suggestions_repository.dart';

@LazySingleton(as: RouteSuggestionsRepository)
class RouteSuggestionsRepositoryImpl extends Repository<RouteSuggestions>
    implements RouteSuggestionsRepository {
  final NavigationApiService _navigationApiService;
  final RouteMapper _routeMapper;

  RouteSuggestionsRepositoryImpl(
    this._navigationApiService,
    this._routeMapper,
  );

  @override
  Future<RouteSuggestions?> loadRouteSuggestionsByStartAndEndLocations({
    required Coordinates startLocation,
    required Coordinates endLocation,
  }) async {
    final List<RouteSuggestions> repoState = await repositoryState$.first;
    final RouteSuggestions? existingRouteSuggestions =
        repoState.firstWhereOrNull(
      (RouteSuggestions routeSuggestions) =>
          routeSuggestions.startLocation == startLocation &&
          routeSuggestions.endLocation == endLocation,
    );
    return existingRouteSuggestions ??
        await _fetchRouteSuggestionsFromDb(startLocation, endLocation);
  }

  Future<RouteSuggestions> _fetchRouteSuggestionsFromDb(
    Coordinates startLocation,
    Coordinates endLocation,
  ) async {
    final NavigationDto navigationDto =
        await _navigationApiService.fetchNavigation(
      startLocation: (
        lat: startLocation.latitude,
        long: startLocation.longitude,
      ),
      destinationLocation: (
        lat: endLocation.latitude,
        long: endLocation.longitude,
      ),
    );
    final RouteSuggestions routeSuggestions = RouteSuggestions(
      startLocation: startLocation,
      endLocation: endLocation,
      routes: navigationDto.routes.map(_routeMapper.mapFromDto).toList(),
    );
    addEntity(routeSuggestions);
    return routeSuggestions;
  }
}
