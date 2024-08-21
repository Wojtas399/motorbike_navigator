import 'package:app_settings/app_settings.dart';
import 'package:injectable/injectable.dart';

@injectable
class DeviceSettingsService {
  void openLocationSettings() {
    AppSettings.openAppSettings(type: AppSettingsType.location);
  }
}
