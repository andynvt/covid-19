import 'package:covid/model/country_info.dart';
import 'package:covid/model/model.dart';
import 'package:covid/service/service.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'main_model.dart';

class MainLogic {
  final MainModel _model;

  MainLogic(this._model) {
    _model.text.listen(search);
  }

  ///LOAD DATA

  void getData(Function(bool) callback) {
    _getGlobal((isOK) {
      AdsService.shared().createBannerAd()
        ..load()
        ..show(anchorType: AnchorType.bottom, anchorOffset: 58);
      callback(isOK);
    });
    _getListCountry(() {
      _getGlobalHistorical();
      _getMyHistorical();
    });
    getNews();
  }

  void _getGlobal(Function(bool) callback) {
    CountryService.shared().getGlobal((info) {
      if(info == null) {
        callback(false);
        return;
      }
      _model.globalInfo = info;
      _model.refresh();
      callback(true);
    });
  }

  void _getListCountry(Function() callback) {
    CountryService.shared().getListCountry((ls) {
      _model.countries.addAll(ls);
      _model.listSearch.addAll(_model.countries.values);

      String cacheCountry =
          CacheService.shared().getString(CacheConfig.MY_COUNTRY);
      if (cacheCountry.isEmpty) {
        _model.myCountry = _model.countries.entries.first.value;
      } else {
        _model.myCountry = _model.countries[cacheCountry];
      }
      _model.refresh();
      callback();
    });
  }

  void _getGlobalHistorical() {
    CountryService.shared().getGlobalHistorical((info) {
      _model.globalHistorical = info;
      _model.refresh();
    });
  }

  void _getMyHistorical() {
    final name = _model.myCountry.name;
    final his = CountryService.shared().countries[name].historical;
    if (his != null) {
      _model.myHistorical = his;
      return;
    }
    CountryService.shared().getMyHistorical(name, () {
      _model.myHistorical = CountryService.shared().countries[name].historical;
      _model.refresh();
    });
  }

  void reloadData(Function(bool) callback) {
    if(_model.globalInfo.updated == null) {
      callback(false);
      return;
    }
    final delta =
        DateTime.now().difference(_model.globalInfo.updated).inMinutes;
    if (delta > 15) {
      _model.countries.clear();
      _model.listSearch.clear();
      getData((isOK) => callback);
    } else {
      callback(true);
    }
  }

  void reloadNews(Function(bool) callback) {
    final news = CountryService.shared().listNews.first.publishedAt;
    final delta = DateTime.now().difference(news).inMinutes;
    if (delta > 15) {
      CountryService.shared().listNews.clear();
      CountryService.shared().newsPage = 1;
      CountryService.shared().getNews((isOK) {
        callback(isOK);
      });
    } else {
      callback(true);
    }
  }

  void getNews() {
    CountryService.shared().getNews((isOK) {});
  }

  ///LOGIC

  void updateCountry(CountryInfo info) {
    CacheService.shared().setString(CacheConfig.MY_COUNTRY, info.name);
    _model.myCountry = info;
    _getMyHistorical();
  }

  void search(String text) {
    _model.listSearch.clear();
    if (text.isEmpty) {
      _model.listSearch.addAll(_model.countries.values);
    } else {
      List<CountryInfo> ls = _model.countries.values.where((info) {
        return info.name.toLowerCase().contains(text.toLowerCase()) ||
            info.name.contains(text);
      }).toList();

      _model.listSearch.addAll(ls);
    }
    _model.refresh();
  }

  void typeFilter(TypeEnum value) {
    _model.typeFilter = value;
    _sort(_model.sortFilter);
  }

  void sortFilter() {
    final sort =
        _model.sortFilter == SortType.DES ? SortType.ACS : SortType.DES;
    _sort(sort);
  }

  void _sort(SortType sort) {
    _model.sortFilter = sort;
    if (sort == SortType.DES) {
      _model.listSearch.sort((a, b) {
        return b
            .getPropertyByTypeEnum(_model.typeFilter)
            .compareTo(a.getPropertyByTypeEnum(_model.typeFilter));
      });
    } else {
      _model.listSearch.sort((a, b) {
        return a
            .getPropertyByTypeEnum(_model.typeFilter)
            .compareTo(b.getPropertyByTypeEnum(_model.typeFilter));
      });
    }
    _model.refresh();
  }

  void selectGlobal(bool value) {
    _model.isGlobal = value;
    _model.refresh();
  }

  void moveToListTab(TypeEnum type) {
    _model.pageIndex = 1;
    _model.typeFilter = type;
    _sort(SortType.DES);
    _model.refresh();
  }

  void moveToPage(CountryInfo info, int index) {
    _model.pageIndex = index;
    _model.myCountry = info;
    _model.refresh();
  }

  void changeTab(int index) {
    _model.pageIndex = index;
    _model.refresh();
  }
}
