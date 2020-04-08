import 'package:flutter/material.dart';

import 'change_language_logic.dart';

class ChangeLanguageModel extends ChangeNotifier {
  ChangeLanguageLogic _logic;
  ChangeLanguageLogic get logic => _logic;

  ChangeLanguageModel() {
    _logic = ChangeLanguageLogic(this);
  }
}
