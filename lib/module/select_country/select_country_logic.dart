import 'package:covid/model/model.dart';
import 'package:covid/service/service.dart';

import 'select_country_model.dart';

class SelectCountryLogic {
  final SelectCountryModel _model;

  SelectCountryLogic(this._model) {
    _loadData();
    _model.text.listen(search);
  }

  void search(String text) {
    _model.listSearch.clear();
    if (text.isEmpty) {
      _model.listSearch.addAll(_model.countries);
    } else {
      List<CountryInfo> ls = _model.countries.where((info) {
        return info.name.toLowerCase().contains(text);
      }).toList();
      _model.listSearch.addAll(ls);
    }
    _model.refresh();
  }

  void _loadData() {
    _model.countries.addAll(CountryService.shared().countries);
    _model.refresh();
  }
}
