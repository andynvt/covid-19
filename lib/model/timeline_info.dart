import 'package:intl/intl.dart';

class TimelineInfo {
  DateTime date;
  int quantity;

  TimelineInfo({this.date, this.quantity});

  factory TimelineInfo.fromJson(String key, int value) {
    final format = DateFormat("MM/dd/yy");
    DateTime date = format.parse(key).add(
        Duration(milliseconds: 63113904000000));
    return TimelineInfo(
      date: date,
      quantity: value,
    );
  }

  static List<TimelineInfo> fromList(Map<String, dynamic> json) {
    if (json == null) {
      return [];
    }
    return json.entries
        .map((e) => TimelineInfo.fromJson(e.key, e.value))
        .toList();
  }
}
