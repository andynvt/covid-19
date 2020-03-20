import 'package:flutter/material.dart';

import 'main_logic.dart';

class MainModel extends ChangeNotifier {
  MainLogic _logic;
  MainLogic get logic => _logic;

  MainModel() {
    _logic = MainLogic(this);
  }
}
