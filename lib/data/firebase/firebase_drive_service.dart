import 'package:injectable/injectable.dart';

import '../dto/drive_dto.dart';
import 'firebase_collections.dart';

@injectable
class FirebaseDriveService {
  Future<List<DriveDto>> fetchAllUserDrives({
    required String userId,
  }) async {
    final snapshot = await getDrivesRef(userId).get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<DriveDto?> addDrive({
    required String userId,
    required DriveDto driveDto,
  }) async {
    final docRef = await getDrivesRef(userId).add(driveDto);
    final snapshot = await docRef.get();
    return snapshot.data();
  }
}
