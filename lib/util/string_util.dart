import 'package:intl/intl.dart';

class TTString {
  static TTString _sInstance;
  final _number = new NumberFormat("#,###");
  final _dateYMD = DateFormat("yyyy.MM.dd");
  final _date = DateFormat("HH:mm - dd MMM yyyy");

  TTString._();

  factory TTString.shared() {
    if (_sInstance == null) {
      _sInstance = TTString._();
    }
    return _sInstance;
  }

  String formatNumber(int number) {
    return _number.format(number);
  }
  
  String formatDateYMD(DateTime date) {
    return _dateYMD.format(date);
  }

  String formatDate(DateTime date) {
    return _date.format(date);
  }
}
