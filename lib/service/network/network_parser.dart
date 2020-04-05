import 'package:covid/model/model.dart';
import 'package:covid/resource/resource.dart';
import 'package:covid/service/cache/cache_config.dart';
import 'package:covid/service/cache/cache_service.dart';

typedef ParseCallback = Map<String, dynamic> Function(dynamic);

class NetworkParser {
  NetworkParser._();

  static Map<String, dynamic> getListCountryName(dynamic json) {
    if (json is Map<String, dynamic> && json.containsKey('countries')) {
      final data = json['countries'] as Map<String, dynamic>;
      return {'list': data};
    }
    return {'list': []};
  }

  static Map<String, dynamic> getGlobalHistorical(dynamic json) {
    if (json is Map<String, dynamic>) {
      final info = HistoricalInfo.fromJson(json);
      final cases = info.cases;

      final List<TimelineInfo> activeList = [];
      for (int i = 0; i < cases.length; i++) {
        final quantity = cases[i].quantity -
            info.recovered[i].quantity -
            info.deaths[i].quantity;
        final timeline = TimelineInfo(date: cases[i].date, quantity: quantity);
        activeList.add(timeline);
      }
      info.active = activeList;
      return {'info': info};
    }
    return {};
  }

  static Map<String, dynamic> getMyHistorical(dynamic json) {
    if (json is Map<String, dynamic> && json.containsKey('timeline')) {
      final info = HistoricalInfo.fromJson(json['timeline']);
      final cases = info.cases;

      final List<TimelineInfo> activeList = [];
      for (int i = 0; i < cases.length; i++) {
        final quantity = cases[i].quantity -
            info.recovered[i].quantity -
            info.deaths[i].quantity;
        final timeline = TimelineInfo(date: cases[i].date, quantity: quantity);
        activeList.add(timeline);
      }
      info.active = activeList;
      return {'info': info};
    }
    return {};
  }

  static Map<String, dynamic> getGlobal(dynamic json) {
    if (json is Map<String, dynamic>) {
      final info = CountryInfo.fromJson(json);
      return {'info': info};
    }
    return {};
  }

  static Map<String, dynamic> getListCountry(dynamic json) {
    if (json is List<dynamic>) {
      final Map<String, CountryInfo> map = Map.fromIterable(json,
          key: (e) => e['country'], value: (e) => CountryInfo.fromJson(e));
//      CountryInfo global = map['World'];
//      global.name = 'GLOBAL';
//      map.remove('World');
      map.values
        ..toList().sort((a, b) {
          return b.cases.compareTo(a.cases);
        });
      return {'map': map};
    }
    return {};
  }

  static Map<String, dynamic> getListNewsGlobal(dynamic json) {
    if (json is Map<String, dynamic> && json.containsKey('articles')) {
      final items = json['articles'];
      if (items is List<dynamic> && items.length > 0) {
        final ls = items.map((e) {
          return NewsInfo.fromJson(e);
        }).toList();
        return {'list': ls};
      }
    }
    return {};
  }

//  static Map<String, dynamic> getListNews(dynamic json) {
//    if (json is Map<String, dynamic> && json.containsKey('countrynewsitems')) {
//      final items = json['countrynewsitems'];
//      if (items is List<dynamic> && items.length > 0) {
//        final Map<String, dynamic> item = items[0];
//        item.remove('stat');
//        final ls = item.values.map((e) {
//          return NewsInfo.fromJson(e);
//        }).toList();
//
//        ls.removeWhere((element) => element.title.isEmpty);
//        return {'news': ls};
//      }
//    }
//    return {};
//  }
}
