import 'package:covid/model/model.dart';
import 'package:flutter/cupertino.dart';

import '../service.dart';

class CountryService extends ChangeNotifier implements BaseService {
  static CountryService _sInstance;

  List<CountryInfo> countries = [];
  GlobalInfo globalInfo;
  HistoricalInfo globalHistorical;
  HistoricalInfo myHistorical;

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


  void getData(Function() callback) {
    if (globalInfo != null || countries.isNotEmpty) {
      return;
    }
    _getGlobal(() {
      _getHistoricalAll(() {
        _getListCountry(() {
          callback();
          _refresh();
        });
      });
    });
  }

  void getMyHistorical(String country, Function() callback) {
    NetworkService.shared().sendGETRequest(
      url: NetworkAPI.getHistoricalByName(country),
      parser: NetworkParser.getMyHistorical,
      callback: (rs) {
        if (rs.isOK && rs.data.containsKey('info')) {
          myHistorical = rs.data['info'];
        } else if (d___) {
          print('---> getMyHistorical error: ${rs.msgError}');
        }
        callback();
      },
    );
  }

  void _getGlobal(Function() callback) {
    NetworkService.shared().sendGETRequest(
      url: NetworkAPI.GET_GLOBAL,
      parser: NetworkParser.getGlobal,
      callback: (rs) {
        if (rs.isOK && rs.data.containsKey('info')) {
          globalInfo = rs.data['info'];
        } else if (d___) {
          print('---> getGlobal error: ${rs.msgError}');
        }
        callback();
      },
    );
  }

  void _getHistoricalAll(Function() callback) {
    NetworkService.shared().sendGETRequest(
      url: NetworkAPI.GET_HISTORICAL,
      parser: NetworkParser.getHistorical,
      callback: (rs) {
        if (rs.isOK && rs.data.containsKey('info')) {
          globalHistorical = rs.data['info'];
        } else if (d___) {
          print('---> _getHistoricalAll error: ${rs.msgError}');
        }
        callback();
      },
    );
  }

  void _getListCountry(Function() callback) {
    NetworkService.shared().sendGETRequest(
      url: NetworkAPI.GET_COUNTRIES,
      parser: NetworkParser.getListCountry,
      callback: (rs) {
        if (rs.isOK && rs.data.containsKey('list')) {
          final List<CountryInfo> ls = rs.data['list'];
          ls.sort((a, b) {
            return b.cases.compareTo(a.cases);
          });
          countries.addAll(ls);
        } else if (d___) {
          print('---> getListCountry error: ${rs.msgError}');
        }
        callback();
      },
    );
  }

  void _refresh() {
    notifyListeners();
  }
}
