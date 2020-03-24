import 'package:flutter/material.dart';
import 'main_logic.dart';

enum CountryType { MINE, WORLD }

class MainModel extends ChangeNotifier {
  MainLogic _logic;

  MainLogic get logic => _logic;

  bool isWorld = false;

  MainModel() {
    _logic = MainLogic(this);
  }

  void refresh() {
    notifyListeners();
  }
}
