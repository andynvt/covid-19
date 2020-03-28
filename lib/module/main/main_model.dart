import 'package:covid/model/model.dart';
import 'package:flutter/material.dart';
import 'main_logic.dart';

enum CountryType { MINE, WORLD }

class MainModel extends ChangeNotifier {
  MainLogic _logic;

  MainLogic get logic => _logic;

  bool isGlobal = true;
  CountryInfo myCountry = CountryInfo(id: -1);

  MainModel() {
    _logic = MainLogic(this);
  }

  void refresh() {
    notifyListeners();
  }
}
