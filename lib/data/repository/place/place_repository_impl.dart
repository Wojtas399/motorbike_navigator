import 'package:collection/collection.dart';
import 'package:injectable/injectable.dart';

import '../../../entity/place.dart';
import '../../api_service/place_api_service.dart';
import '../../dto/place_dto.dart';
import '../../mapper/place_mapper.dart';
import '../repository.dart';
import 'place_repository.dart';

@LazySingleton(as: PlaceRepository)
class PlaceRepositoryImpl extends Repository<Place> implements PlaceRepository {
  final PlaceApiService _placeApiService;

  PlaceRepositoryImpl(this._placeApiService);

  @override
  Future<Place?> getPlaceById(String id) async {
    final repoState = await repositoryState$.first;
    Place? place = repoState?.firstWhereOrNull((entity) => entity.id == id);
    place ??= await _fetchPlaceByIdFromDb(id);
    return place;
  }

  Future<Place?> _fetchPlaceByIdFromDb(String id) async {
    final PlaceDto? placeDto = await _placeApiService.fetchPlaceById(id);
    if (placeDto == null) return null;
    final Place place = mapPlaceFromDto(placeDto);
    addEntity(place);
    return place;
  }
}
