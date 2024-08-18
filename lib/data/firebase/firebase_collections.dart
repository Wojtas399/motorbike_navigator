import 'package:cloud_firestore/cloud_firestore.dart';

import '../dto/user_dto.dart';

CollectionReference<UserDto> getUsersRef() =>
    FirebaseFirestore.instance.collection('Users').withConverter<UserDto>(
          fromFirestore: (snapshot, _) {
            final data = snapshot.data();
            if (data == null) throw 'User document data was null';
            return UserDto.fromFirebaseFirestore(
              id: snapshot.id,
              json: data,
            );
          },
          toFirestore: (UserDto dto, _) => dto.toJson(),
        );
