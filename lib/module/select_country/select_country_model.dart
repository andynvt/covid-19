import 'package:covid/model/model.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import 'select_country_logic.dart';

class SelectCountryModel extends ChangeNotifier {
  SelectCountryLogic _logic;
  SelectCountryLogic get logic => _logic;

  final text = BehaviorSubject.seeded('');
  final List<CountryInfo> countries = [];

  SelectCountryModel() {
    _logic = SelectCountryLogic(this);
  }

  @override
  void dispose() {
    text.close();
    super.dispose();
  }

  void refresh() {
    notifyListeners();
  }
}
