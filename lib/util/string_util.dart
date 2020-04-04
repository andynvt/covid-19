import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeAgo;

class TTString {
  static TTString _sInstance;
  final _number = new NumberFormat("#,###");
  final _dateYMD = DateFormat("yyyy.MM.dd");
  final _date = DateFormat("HH:mm - dd MMM yyyy");
  final _dateMonth = DateFormat("dd MMM");

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
  String formatDateMonth(DateTime date) {
    return _dateMonth.format(date);
  }
  String formatTimeAgo(DateTime date, {bool isShort = false}) {
    return timeAgo.format(date, locale: isShort ? 'en_short' : 'en');
  }
}
