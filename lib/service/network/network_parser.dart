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

  static Map<String, dynamic> getListCountry(dynamic json) {
    if (json is List<dynamic>) {
      final ls = json.map((e) {
        return CountryInfo.fromJson(e);
      }).toList();
      return {'list': ls};
    }
    return {};
  }

  static Map<String, dynamic> getGlobal(dynamic json) {
    if (json is Map<String, dynamic>) {
      final info = GlobalInfo.fromJson(json);
      return {'info': info};
    }
    return {};
  }
}
