import 'package:collection/collection.dart';
import 'package:injectable/injectable.dart';

import '../../../entity/coordinates.dart';
import '../../../entity/navigation.dart';
import '../../api_service/navigation_api_service.dart';
import '../../dto/navigation_dto.dart';
import '../../mapper/navigation_mapper.dart';
import '../repository.dart';
import 'navigation_repository.dart';

@LazySingleton(as: NavigationRepository)
class NavigationRepositoryImpl extends Repository<Navigation>
    implements NavigationRepository {
  final NavigationApiService _navigationApiService;

  NavigationRepositoryImpl(this._navigationApiService);

  @override
  Future<Navigation?> loadNavigationByStartAndEndLocations({
    required Coordinates startLocation,
    required Coordinates endLocation,
  }) async {
    final List<Navigation>? repoState = await repositoryState$.first;
    final Navigation? existingNavigation = repoState?.firstWhereOrNull(
      (Navigation navigation) =>
          navigation.startLocation == startLocation &&
          navigation.endLocation == endLocation,
    );
    return existingNavigation ??
        await _fetchNavigationFromDb(startLocation, endLocation);
  }

  Future<Navigation> _fetchNavigationFromDb(
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
    final Navigation navigation = mapNavigationFromDto(
      startLocation: startLocation,
      endLocation: endLocation,
      dto: navigationDto,
    );
    addEntity(navigation);
    return navigation;
  }
}
