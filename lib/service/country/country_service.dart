import 'package:covid/model/model.dart';
import 'package:flutter/cupertino.dart';

import '../service.dart';

class CountryService extends ChangeNotifier implements BaseService {
  static CountryService _sInstance;

  Map<String, CountryInfo> countries = {};
  CountryInfo globalInfo;
  HistoricalInfo globalHistorical;
  final List<NewsInfo> listNews = [];
  int newsPage = 1;

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

  void getMyHistorical(String country, Function() callback) {
    NetworkService.shared().sendGETRequest(
      url: NetworkAPI.getHistoricalByName(country),
      parser: NetworkParser.getMyHistorical,
      callback: (rs) {
        if (rs.isOK && rs.data.containsKey('info')) {
          HistoricalInfo info = rs.data['info'];
          countries[country].historical = info;
        } else if (d___) {
          print('---> getMyHistorical error: ${rs.msgError}');
        }
        callback();
      },
    );
  }

  void getNews(Function(bool) callback) {
    if (newsPage == -1 || newsPage > 5) {
      return;
    }
    NetworkService.shared().sendGETRequest(
      url: NetworkAPI.getNewsByPage(newsPage),
      parser: NetworkParser.getListNewsGlobal,
      callback: (rs) {
        if (rs.isOK && rs.data.containsKey('list')) {
          listNews.addAll(rs.data['list']);
          newsPage += 1;
          _refresh();
          callback(true);
        } else if (d___) {
          print('---> getNews error: ${rs.msgError}');
          callback(false);
        }
      },
    );
  }

  void getGlobal(Function(CountryInfo) callback) {
    NetworkService.shared().sendGETRequest(
      url: NetworkAPI.GET_GLOBAL,
      parser: NetworkParser.getGlobal,
      callback: (rs) {
        if (rs.isOK && rs.data.containsKey('info')) {
          globalInfo = rs.data['info'];
        } else if (d___) {
          print('---> getGlobal error: ${rs.msgError}');
        }
        callback(globalInfo);
      },
    );
  }

  void getListCountry(Function(Map<String, CountryInfo>) callback) {
    NetworkService.shared().sendGETRequest(
      url: NetworkAPI.GET_COUNTRIES,
      parser: NetworkParser.getListCountry,
      params: {'sort': 'cases'},
      callback: (rs) {
        if (rs.isOK && rs.data.containsKey('map')) {
          countries.clear();
          countries.addAll(rs.data['map']);
        } else if (d___) {
          print('---> getListCountry error: ${rs.msgError}');
        }
        callback(countries);
      },
    );
  }

  void getGlobalHistorical(Function(HistoricalInfo) callback) {
    NetworkService.shared().sendGETRequest(
      url: NetworkAPI.GET_GLOBAL_HISTORICAL,
      parser: NetworkParser.getGlobalHistorical,
      callback: (rs) {
        if (rs.isOK && rs.data.containsKey('info')) {
          globalHistorical = rs.data['info'];
        } else if (d___) {
          print('---> _getGlobalHistorical error: ${rs.msgError}');
        }
        callback(globalHistorical);
      },
    );
  }



  void _refresh() {
    notifyListeners();
  }
}
