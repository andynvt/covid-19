import 'package:covid/model/country_info.dart';
import 'package:covid/service/service.dart';
import 'main_model.dart';

class MainLogic {
  final MainModel _model;

  MainLogic(this._model) {
    loadData();
  }

  void loadData() {
    CountryService.shared().getData(() {
      _model.myCountry = CountryService.shared().countries.first;
      _model.globalInfo = CountryService.shared().globalInfo;
      _model.globalHistorical = CountryService.shared().globalHistorical;
      getMyHistorical(() {
        _model.refresh();
      });
    });
  }
  
  void getMyHistorical(Function() callback) {
    CountryService.shared().getMyHistorical(_model.myCountry.name, () {
      _model.myHistorical = CountryService.shared().myHistorical;
      callback();
    });
  }

  void selectGlobal(bool value) {
    _model.isGlobal = value;
    _model.refresh();
  }

  void updateCountry(CountryInfo info) {
    //TODO: save country to cache
    _model.myCountry = info;
    _model.refresh();
  }
}
