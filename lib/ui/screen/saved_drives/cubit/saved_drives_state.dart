import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../entity/drive.dart';

part 'saved_drives_state.freezed.dart';

enum SavedDrivesStateStatus { loading, completed }

@freezed
class SavedDrivesState with _$SavedDrivesState {
  const factory SavedDrivesState({
    @Default(SavedDrivesStateStatus.loading) SavedDrivesStateStatus status,
    @Default([]) List<Drive> drives,
  }) = _SavedDrivesState;
}
