import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../data/repository/drive/drive_repository.dart';
import '../../../../entity/drive.dart';
import 'saved_drives_state.dart';

@injectable
class SavedDrivesCubit extends Cubit<SavedDrivesState> {
  final DriveRepository _driveRepository;
  StreamSubscription<List<Drive>>? _drivesListener;

  SavedDrivesCubit(
    this._driveRepository,
  ) : super(const SavedDrivesState());

  @override
  Future<void> close() {
    _drivesListener?.cancel();
    return super.close();
  }

  void initialize() async {
    _drivesListener ??=
        _driveRepository.getAllDrives().listen(_handleLoggedUserDrives);
  }

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
