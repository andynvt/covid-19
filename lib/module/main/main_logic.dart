import 'package:covid/model/country_info.dart';
import 'package:covid/model/model.dart';
import 'package:covid/service/service.dart';
import 'main_model.dart';

class MainLogic {
  final MainModel _model;

  MainLogic(this._model) {
    loadData();
    _model.text.listen(search);
  }

  void loadData() {
    CountryService.shared().getData(() {
      _model.countries.addAll(CountryService.shared().countries);
      _model.listSearch.addAll(_model.countries.values);
      _model.myCountry = _model.countries.entries.first.value;
      _model.globalInfo = CountryService.shared().globalInfo;
      _model.globalHistorical = CountryService.shared().globalHistorical;
      getNews();
      getMyHistorical(_model.myCountry.name, () {
        _model.refresh();
      });
    });
  }

  void getMyHistorical(String name, Function() callback) {
    final his = CountryService.shared().countries[name].historical;
    if (his != null) {
      _model.myHistorical = his;
      return;
    }
    CountryService.shared().getMyHistorical(name, () {
      _model.myHistorical = CountryService.shared().countries[name].historical;
      callback();
    });
  }

  void updateCountry(CountryInfo info) {
    //TODO: save country to cache
    _model.myCountry = info;
    getMyHistorical(_model.myCountry.name, () {
      _model.refresh();
    });
  }

  void search(String text) {
    _model.listSearch.clear();
    if (text.isEmpty) {
      _model.listSearch.addAll(_model.countries.values);
    } else {
      List<CountryInfo> ls = _model.countries.values.where((info) {
        return info.name.toLowerCase().contains(text);
      }).toList();
      _model.listSearch.addAll(ls);
    }
    _model.refresh();
  }

  void typeFilter(String value) {
    _model.typeFilter = strToTypeEnum(value);
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

  void getNews() {
    final myCountry = _model.myCountry;
    final news = CountryService.shared().countries[myCountry.name].news;
    if (news.isNotEmpty) {
      _model.news.clear();
      _model.news.addAll(news);
      return;
    }
    CountryService.shared().getNewsByCountyCode(myCountry.name, myCountry.code,
        () {
      _model.news
          .addAll(CountryService.shared().countries[myCountry.name].news);
      _model.refresh();
    });
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

  void changeTab(int index) {
    _model.pageIndex = index;
    String title = '';
    switch (index) {
      case 0:
        title = 'Covid-19 Chart';
        break;
      case 1:
        title = 'Covid-19 List';
        break;
      case 2:
        title = 'Covid-19 Overview';
        break;
      case 3:
        title = 'Covid-19 Map';
        break;
      case 4:
        title = 'Covid-19 News';
        break;
    }
    _model.title = title;
    _model.refresh();
  }
}
