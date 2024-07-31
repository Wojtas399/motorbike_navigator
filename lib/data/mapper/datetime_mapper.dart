import 'package:injectable/injectable.dart';

import '../../ui/service/number_service.dart';
import 'mapper.dart';

@injectable
class DateTimeMapper extends Mapper<DateTime, String> {
  final NumberService _numberService;

  const DateTimeMapper(this._numberService);

  @override
  DateTime mapFromDto(String dto) {
    final List<String> dateParts = dto.split('-');
    final int year = int.parse(dateParts.first);
    final int month = int.parse(dateParts[1]);
    final int day = int.parse(dateParts.last);
    return DateTime(year, month, day);
  }

  @override
  String mapToDto(DateTime object) {
    final String monthStr = _numberService.twoDigits(object.month);
    final String dayStr = _numberService.twoDigits(object.day);
    return '${object.year}-$monthStr-$dayStr';
  }
}
