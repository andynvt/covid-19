import 'package:flutter/material.dart';

import 'test_logic.dart';

class TestModel extends ChangeNotifier {
  TestLogic _logic;
  TestLogic get logic => _logic;

  TestModel() {
    _logic = TestLogic(this);
  }
}
