import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../entity/coordinates.dart';
import '../../service/location_service.dart';

part 'location_provider.g.dart';

@riverpod
Future<Coordinates?> location(LocationRef ref) =>
    ref.watch(locationServiceProvider).getCurrentPosition();
