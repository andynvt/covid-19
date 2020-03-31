import 'package:covid/util/string_util.dart';

import 'timeline_info.dart';

class HistoricalInfo {
  final List<TimelineInfo> cases;
  final List<TimelineInfo> deaths;
  final List<TimelineInfo> recovered;
  List<TimelineInfo> active;

  HistoricalInfo({this.cases, this.deaths, this.recovered, this.active});

  factory HistoricalInfo.fromJson(Map<String, dynamic> json) {
    return HistoricalInfo(
      cases: TimelineInfo.fromList(json['cases']),
      deaths: TimelineInfo.fromList(json['deaths']),
      recovered: TimelineInfo.fromList(json['recovered']),
    );
  }

  String toDateList({int count}) {
    final ls = _takeList(cases, count).reversed;
    String str = '[';
    ls.forEach((e) {
      str += '"${TTString.shared().formatDateMonth(e.date)}",';
    });
    str += ']';
    return str;
  }

  String toDataList(List<TimelineInfo> list, {int count}) {
    final ls = _takeList(list, count).reversed;
    String str = '[';
    ls.forEach((e) {
      str += '${e.quantity},';
    });
    str += ']';
    return str;
  }

  List<TimelineInfo> _takeList(List<TimelineInfo> list, int count) {
    List<TimelineInfo> ls = [];
    final int c = count == null ? list.length : count;
    ls.addAll(list.reversed.take(c));
    return ls;
  }

}
