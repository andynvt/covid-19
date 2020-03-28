import 'package:covid/model/country_info.dart';
import 'package:covid/service/service.dart';
import 'main_model.dart';

class MainLogic {
  final MainModel _model;

  MainLogic(this._model) {
    _loadGlobal();
  }

  void _loadGlobal() {
    CountryService.shared().getData(() {
      _model.myCountry = CountryService.shared().countries.first;
      _model.refresh();
    });
  }

  void selectGlobal() {
    _model.isGlobal = !_model.isGlobal;
    _model.refresh();
  }

  void updateCountry(CountryInfo info) {
    //TODO: save country to cache
    _model.myCountry = info;
    _model.refresh();
  }
}
