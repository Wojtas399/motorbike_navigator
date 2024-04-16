import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../entity/place.dart';
import 'place_repository.dart';

part 'place_repository_method_providers.g.dart';

@riverpod
Future<Place?> getPlaceById(GetPlaceByIdRef ref, String id) async =>
    ref.watch(placeRepositoryProvider).getPlaceById(id);
