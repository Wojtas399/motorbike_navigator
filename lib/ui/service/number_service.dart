import 'package:injectable/injectable.dart';

@injectable
class NumberService {
  String twoDigits(int number) => number.toString().padLeft(2, '0');
}
