import 'package:cloud_firestore/cloud_firestore.dart';

import '../dto/drive_dto.dart';
import '../dto/user_dto.dart';

CollectionReference<UserDto> getUsersRef() =>
    FirebaseFirestore.instance.collection('Users').withConverter<UserDto>(
          fromFirestore: (snapshot, _) {
            final data = snapshot.data();
            if (data == null) throw 'User document data was null';
            return UserDto.fromIdAndJson(snapshot.id, data);
          },
          toFirestore: (UserDto dto, _) => dto.toJson(),
        );

CollectionReference<DriveDto> getDrivesRef(
  String userId,
) =>
    FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .collection('Drives')
        .withConverter<DriveDto>(
          fromFirestore: (snapshot, _) {
            final data = snapshot.data();
            if (data == null) throw 'Drive document data was null';
            return DriveDto.fromFirebaseFirestore(
              driveId: snapshot.id,
              userId: userId,
              json: data,
            );
          },
          toFirestore: (DriveDto dto, _) => dto.toJson(),
        );
