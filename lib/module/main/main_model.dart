import 'package:flutter/material.dart';

import 'main_logic.dart';

enum typeEnum {
  CONFIRMED, RECOVERED, DEATH, CRITICAL, CASE_TODAY, DEATH_TODAY
}

class MainModel extends ChangeNotifier {
  MainLogic _logic;
  MainLogic get logic => _logic;

  MainModel() {
    _logic = MainLogic(this);
  }
}
