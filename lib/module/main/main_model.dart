import 'package:covid/model/model.dart';
import 'package:flutter/material.dart';
import 'main_logic.dart';

enum CountryType { MINE, WORLD }

class MainModel extends ChangeNotifier {
  MainLogic _logic;

  MainLogic get logic => _logic;

  int pageIndex = 0;
  bool isGlobal = true;
  CountryInfo myCountry = CountryInfo(id: -1);
  GlobalInfo globalInfo = GlobalInfo();
  HistoricalInfo globalHistorical = HistoricalInfo();
  HistoricalInfo myHistorical = HistoricalInfo();

  MainModel() {
    _logic = MainLogic(this);
  }

  void refresh() {
    notifyListeners();
  }
}
