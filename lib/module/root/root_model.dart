import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import 'root_logic.dart';

class RootModel extends ChangeNotifier {
  RootLogic _logic;
  RootLogic get logic => _logic;
  final isLoading = BehaviorSubject.seeded(false);
  var loadingKey = '';
  Locale currentLocale;

  RootModel() {
    _logic = RootLogic(this);
  }

  void refresh() {
    notifyListeners();
  }

  @override
  void dispose() {
    isLoading.close();
    super.dispose();
  }
}
