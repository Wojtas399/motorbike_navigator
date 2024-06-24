import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'drive_state.dart';

@injectable
class DriveCubit extends Cubit<DriveState> {
  DriveCubit() : super(const DriveState());

  void startDrive() {
    //TODO
  }
}
