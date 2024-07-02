import 'package:injectable/injectable.dart';

import '../dto/drive_dto.dart';
import 'firebase_collections.dart';

@injectable
class FirebaseDriveService {
  Future<List<DriveDto>> fetchAllDrives({
    required String userId,
  }) async {
    final snapshot = await getDrivesRef(userId).get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<void> addDrive({
    required String userId,
    required DriveDto driveDto,
  }) async {
    await getDrivesRef(userId).add(driveDto);
  }
}
