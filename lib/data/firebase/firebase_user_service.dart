import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

import '../dto/user_dto.dart';
import 'firebase_collections.dart';

@injectable
class FirebaseUserService {
  Future<UserDto?> fetchUserById({
    required String userId,
  }) async {
    final snapshot = await getUsersRef().doc(userId).get();
    return snapshot.data();
  }

  Future<UserDto?> addUser({
    required String userId,
    required ThemeModeDto themeMode,
  }) async {
    final docRef = getUsersRef().doc(userId);
    await docRef.set(
      UserDto(
        themeMode: themeMode,
      ),
    );
    final snapshot = await docRef.get();
    return snapshot.data();
  }

  Future<UserDto?> updateUserThemeMode({
    required String userId,
    required ThemeModeDto themeMode,
  }) async {
    final docRef = getUsersRef().doc(userId);
    DocumentSnapshot<UserDto> doc = await docRef.get();
    UserDto? data = doc.data();
    if (data == null) {
      throw '[FirebaseUserService] Cannot find doc data';
    }
    data = data.copyWith(
      themeMode: themeMode,
    );
    await docRef.set(data);
    final snapshot = await docRef.get();
    return snapshot.data();
  }
}
