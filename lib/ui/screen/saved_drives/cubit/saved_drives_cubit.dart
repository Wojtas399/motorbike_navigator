import 'dart:async';

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
  StreamSubscription<List<Drive>>? _drivesListener;

  SavedDrivesCubit(
    this._authRepository,
    this._driveRepository,
  ) : super(const SavedDrivesState());

  @override
  Future<void> close() {
    _drivesListener?.cancel();
    return super.close();
  }

  void initialize() async {
    _drivesListener ??= _getLoggedUserDrives().listen(_handleLoggedUserDrives);
  }

  Stream<List<Drive>> _getLoggedUserDrives() =>
      _authRepository.loggedUserId$.whereNotNull().switchMap(
            (String loggedUserId) => _driveRepository.getAllDrives(),
          );

  void _handleLoggedUserDrives(List<Drive> drives) {
    final List<Drive> sortedDrives = [...drives];
    sortedDrives.sort(
      (d1, d2) => d2.startDateTime.compareTo(d1.startDateTime),
    );
    emit(state.copyWith(
      status: SavedDrivesStateStatus.completed,
      drives: sortedDrives,
    ));
  }
}
