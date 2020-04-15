import 'package:covid/model/model.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'main_logic.dart';

enum PageType { HOME, NEWS }

enum SortType { DES, ACS }

class MainModel extends ChangeNotifier {
  MainLogic _logic;

  MainLogic get logic => _logic;

  int openTimes = 0;
  int pageIndex = 2;
  int sourceIndex = 2;
  bool isGlobal = true;
  CountryInfo myCountry = CountryInfo();
  CountryInfo globalInfo = CountryInfo();
  HistoricalInfo globalHistorical = HistoricalInfo();
  HistoricalInfo myHistorical = HistoricalInfo();

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
