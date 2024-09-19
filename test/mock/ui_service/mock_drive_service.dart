import 'package:mocktail/mocktail.dart';
import 'package:motorbike_navigator/ui/service/drive_service.dart';

class MockDriveService extends Mock implements DriveService {
  void mockGetDefaultTitle({
    required String expectedTitle,
  }) {
    when(getDefaultTitle).thenReturn(expectedTitle);
  }
}
