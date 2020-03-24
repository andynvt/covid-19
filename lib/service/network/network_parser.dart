import 'package:covid/model/model.dart';
import 'package:covid/resource/resource.dart';

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
      CountryInfo myCountry;
      final ls = json.map((e) {
        if (e['country'] == CS.COUNTRY) {
          myCountry = CountryInfo.fromJson(e);
        }
        return CountryInfo.fromJson(e);
      }).toList();
      return {'list': ls, 'myCountry': myCountry};
    }
    return {};
  }
}
