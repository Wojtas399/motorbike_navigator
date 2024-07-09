import 'package:injectable/injectable.dart';

import '../../entity/place_suggestion.dart';
import '../dto/place_suggestion_dto.dart';
import 'mapper.dart';

@injectable
class PlaceSuggestionMapper
    extends Mapper<PlaceSuggestion, PlaceSuggestionDto> {
  @override
  PlaceSuggestion mapFromDto(PlaceSuggestionDto dto) => PlaceSuggestion(
        id: dto.id,
        name: dto.name,
        fullAddress: dto.fullAddress,
      );
}
