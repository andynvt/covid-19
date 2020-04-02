import 'package:covid/model/model.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'main_logic.dart';

enum PageType { HOME, NEWS }

enum SortType { DES, ACS }

class MainModel extends ChangeNotifier {
  MainLogic _logic;

  MainLogic get logic => _logic;

  int pageIndex = 2;
  String title = 'Covid-19';
  bool isGlobal = true;
  CountryInfo myCountry = CountryInfo(id: -1);
  GlobalInfo globalInfo = GlobalInfo();
  HistoricalInfo globalHistorical = HistoricalInfo();
  HistoricalInfo myHistorical = HistoricalInfo();
  final List<NewsInfo> news = [];

  final text = BehaviorSubject.seeded('');
  final Map<String, CountryInfo> countries = {};
  final List<CountryInfo> listSearch = [];
  TypeEnum typeFilter = TypeEnum.TOTAL;
  SortType sortFilter = SortType.DES;

  MainModel() {
    _logic = MainLogic(this);
  }

  void refresh() {
    notifyListeners();
  }

  @override
  void dispose() {
    text.close();
    super.dispose();
  }
}
