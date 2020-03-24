import 'package:covid/model/country_info.dart';
import 'package:flutter/cupertino.dart';

import '../service.dart';

class CountryService extends ChangeNotifier implements BaseService {
  static CountryService _sInstance;

  List<CountryInfo> countries = [];
  CountryInfo myCountry;

  @override
  // ignore: non_constant_identifier_names
  bool d___ = BaseService.sd___;

  CountryService._();

  factory CountryService.shared() {
    if (_sInstance == null) {
      _sInstance = CountryService._();
    }
    return _sInstance;
  }

  void getListCountry() {
    NetworkService.shared().sendGETRequest(
      url: NetworkAPI.GET_COUNTRIES,
      parser: NetworkParser.getListCountry,
      callback: (rs) {
        if (rs.isOK && rs.data.containsKey('list')) {
          countries.addAll(rs.data['list']);
          myCountry = rs.data['myCountry'];
          _refresh();
        } else if (d___) {
          print('---> getListCountry error: ${rs.msgError}');
        }
      },
    );
  }

  void _refresh() {
    notifyListeners();
  }
}
