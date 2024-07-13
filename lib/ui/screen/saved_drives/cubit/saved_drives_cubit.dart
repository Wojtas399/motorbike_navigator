import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../data/repository/auth/auth_repository.dart';
import '../../../../data/repository/drive/drive_repository.dart';
import '../../../../entity/drive.dart';
import 'saved_drives_state.dart';

@injectable
class SavedDrivesCubit extends Cubit<SavedDrivesState> {
  final AuthRepository _authRepository;
  final DriveRepository _driveRepository;

  SavedDrivesCubit(
    this._authRepository,
    this._driveRepository,
  ) : super(const SavedDrivesState());

  Future<void> initialize() async {
    final Stream<List<Drive>> loggedUserDrives$ = _getLoggedUserDrives();
    await for (final loggedUserDrives in loggedUserDrives$) {
      final List<Drive> sortedDrives = [...loggedUserDrives];
      sortedDrives.sort(
        (d1, d2) => d2.startDateTime.compareTo(d1.startDateTime),
      );
      emit(state.copyWith(
        status: SavedDrivesStateStatus.completed,
        drives: sortedDrives,
      ));
    }
  }

  Stream<List<Drive>> _getLoggedUserDrives() =>
      _authRepository.loggedUserId$.switchMap(
        (String? loggedUserId) {
          if (loggedUserId == null) {
            throw '[SavedDrivesCubit] Cannot find logged user';
          }
          return _driveRepository.getAllUserDrives(userId: loggedUserId);
        },
      );
}
