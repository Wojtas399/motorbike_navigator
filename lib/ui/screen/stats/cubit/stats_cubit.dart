import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../data/repository/auth/auth_repository.dart';
import '../../../../data/repository/drive/drive_repository.dart';
import '../../../../entity/drive.dart';
import '../../../cubit/date_range/date_range_cubit.dart';
import '../../../service/date_service.dart';
import 'stats_state.dart';

@injectable
class StatsCubit extends Cubit<StatsState> {
  final AuthRepository _authRepository;
  final DriveRepository _driveRepository;
  final DateService _dateService;
  StreamSubscription<List<Drive>>? _drivesListener;

  StatsCubit(
    this._authRepository,
    this._driveRepository,
    this._dateService,
  ) : super(const StatsState());

  @override
  Future<void> close() {
    _drivesListener?.cancel();
    return super.close();
  }

  void onDateRangeChanged({
    required DateRange dateRange,
  }) {
    _drivesListener?.cancel();
    _drivesListener = _authRepository.loggedUserId$
        .whereNotNull()
        .switchMap(
          (String loggedUserId) => _driveRepository.getUserDrivesFromDateRange(
            userId: loggedUserId,
            firstDateOfRange: dateRange.firstDateOfRange,
            lastDateOfRange: dateRange.lastDateOfRange,
          ),
        )
        .listen((drives) => _handleDrives(drives, dateRange));
  }

  void _handleDrives(List<Drive> drives, DateRange dateRange) {
    emit(state.copyWith(
      status: StatsStateStatus.completed,
      numberOfDrives: drives.length,
      mileageInKm: _calculateTotalDrivesMileage(drives),
      totalDuration: _calculateTotalDrivesDuration(drives),
      mileageChartData: _createMileageChartData(dateRange, drives),
    ));
  }

  List<MileageChartData> _createMileageChartData(
    DateRange dateRange,
    List<Drive> drives,
  ) =>
      switch (dateRange) {
        WeeklyDateRange() =>
          _createMileageChartDataForEachDayInDateRange(dateRange, drives),
        MonthlyDateRange() =>
          _createMileageChartDataForEachDayInDateRange(dateRange, drives),
        YearlyDateRange() => _createMileageChartDataForEachMonthInAYear(
            dateRange.firstDateOfRange.year,
            drives,
          ),
      };

  double _calculateTotalDrivesMileage(Iterable<Drive> drives) =>
      drives.isNotEmpty
          ? drives.map((Drive drive) => drive.distanceInKm).reduce(
                (double totalDistance, double driveDistance) =>
                    totalDistance + driveDistance,
              )
          : 0;

  Duration _calculateTotalDrivesDuration(Iterable<Drive> drives) =>
      drives.isNotEmpty
          ? drives.map((Drive drive) => drive.duration).reduce(
                (Duration totalDuration, Duration driveDuration) =>
                    totalDuration + driveDuration,
              )
          : const Duration();

  List<MileageChartData> _createMileageChartDataForEachDayInDateRange(
    DateRange dateRange,
    List<Drive> drives,
  ) =>
      List.generate(
        _dateService.calculateNumberOfDaysBetweenDatesInclusively(
          dateRange.firstDateOfRange,
          dateRange.lastDateOfRange,
        ),
        (int itemIndex) {
          final DateTime date = dateRange.firstDateOfRange.add(
            Duration(days: itemIndex),
          );
          final Iterable<Drive> drivesStartedAtDay = drives.where(
            (Drive drive) => _dateService.areDatesEqual(
              drive.startDateTime,
              date,
            ),
          );
          final double totalMileageFromDrivesStartedAtDay =
              _calculateTotalDrivesMileage(drivesStartedAtDay);
          return MileageChartData(
            date: date,
            value: totalMileageFromDrivesStartedAtDay,
          );
        },
      );

  List<MileageChartData> _createMileageChartDataForEachMonthInAYear(
    int year,
    List<Drive> drives,
  ) =>
      List.generate(
        12,
        (int itemIndex) {
          final DateTime date = DateTime(year, itemIndex + 1);
          final Iterable<Drive> drivesStartedInMonth = drives.where(
            (Drive drive) => _dateService.areMonthsEqual(
              drive.startDateTime,
              date,
            ),
          );
          final double totalMileageFromDrivesStartedInMonth =
              _calculateTotalDrivesMileage(drivesStartedInMonth);
          return MileageChartData(
            date: date,
            value: totalMileageFromDrivesStartedInMonth,
          );
        },
      );
}
