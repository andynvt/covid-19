import 'package:flutter/material.dart';

import 'splash_logic.dart';

class SplashModel extends ChangeNotifier {
  SplashLogic _logic;
  SplashLogic get logic => _logic;

  SplashModel() {
    _logic = SplashLogic(this);
  }
}
