import 'package:covid/model/model.dart';
import 'package:flutter/cupertino.dart';

import '../service.dart';

class CountryService extends ChangeNotifier implements BaseService {
  static CountryService _sInstance;

  Map<String, CountryInfo> countries = {};
  GlobalInfo globalInfo;
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
          HistoricalInfo info = rs.data['info'];
          countries[country].historical = info;
        } else if (d___) {
          print('---> getMyHistorical error: ${rs.msgError}');
        }
        callback();
      },
    );
  }

  void getNews() {
    if(newsPage == -1 || newsPage > 5) {
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
        } else if (d___) {
          print('---> getNews error: ${rs.msgError}');
        }
      },
    );
  }

//  void getNewsByCountyCode(String name, String code, Function() callback) {
//    NetworkService.shared().sendGETRequest(
//      url: NetworkAPI.GET_NEWS,
//      params: {'countryNewsTotal': code},
//      parser: NetworkParser.getListNews,
//      callback: (rs) {
//        if (rs.isOK && rs.data.containsKey('news')) {
//          countries[name].news.addAll(rs.data['news']);
//        } else if (d___) {
//          print('---> getNewsByCountyCode error: ${rs.msgError}');
//        }
//        callback();
//      },
//    );
//  }

  /// PRIVATE FUNCTION
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
          ls.forEach((element) {
            countries[element.name] = element;
          });
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
