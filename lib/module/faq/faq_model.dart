import 'package:flutter/material.dart';

import 'faq_logic.dart';

class FaqModel extends ChangeNotifier {
  FaqLogic _logic;
  FaqLogic get logic => _logic;

  FaqModel() {
    _logic = FaqLogic(this);
  }
}
