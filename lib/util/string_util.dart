import 'package:intl/intl.dart';

class TTString {
  static TTString _sInstance;
  final _number = new NumberFormat("#,###");

  TTString._();

  factory TTString.shared() {
    if (_sInstance == null) {
      _sInstance = TTString._();
    }
    return _sInstance;
  }

  String format(int number) {
    return _number.format(number);
  }

}
