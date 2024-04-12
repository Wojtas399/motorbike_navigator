import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'location_service.dart';

part 'location_provider.g.dart';

@riverpod
Future<MapPosition?> location(LocationRef ref) =>
    ref.watch(locationServiceProvider).getCurrentPosition();
