import 'package:envied/envied.dart';

part 'env.g.dart';

@envied
abstract class Env {
  @EnviedField(varName: 'MAPBOX_ACCESS_TOKEN')
  static const String mapboxAccessToken = _Env.mapboxAccessToken;

  @EnviedField(varName: 'MAPBOX_TEMPLATE_URL')
  static const String mapboxTemplateUrl = _Env.mapboxTemplateUrl;
}
