import 'package:cloud_firestore/cloud_firestore.dart';

import '../dto/drive_dto.dart';

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
            return DriveDto.fromIdAndJson(snapshot.id, data);
          },
          toFirestore: (DriveDto dto, _) => dto.toJson(),
        );
