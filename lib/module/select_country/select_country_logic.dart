import 'package:covid/service/service.dart';

import 'select_country_model.dart';

class SelectCountryLogic {
  final SelectCountryModel _model;

  SelectCountryLogic(this._model) {
    _loadData();
  }

  void _loadData() {
    _model.countries.addAll(CountryService.shared().countries);
    _model.refresh();
  }
}
