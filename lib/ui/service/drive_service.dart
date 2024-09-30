import 'package:injectable/injectable.dart';

import 'date_service.dart';

@injectable
class DriveService {
  final DateService _dateService;

  const DriveService(this._dateService);

  String getDefaultTitle() {
    final DateTime now = _dateService.getNow();
    final PartOfTheDay partOfTheDay = _dateService.getPartOfTheDay(now);
    final String prefix = switch (partOfTheDay) {
      PartOfTheDay.morning => 'Poranny',
      PartOfTheDay.afternoon => 'Popołudniowy',
      PartOfTheDay.evening => 'Wieczorny',
      PartOfTheDay.night => 'Nocny',
    };
    return '$prefix przejazd';
  }
}
