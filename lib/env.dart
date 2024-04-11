import 'package:envied/envied.dart';

part 'env.g.dart';

@envied
abstract class Env {
  @EnviedField(varName: 'MAPBOX_ACCESS_TOKEN')
  static const String mapboxAccessToken = _Env.mapboxAccessToken;

  @EnviedField(varName: 'MAPBOX_STYLE_URI')
  static const String mapboxStyleUri = _Env.mapboxStyleUri;
}
