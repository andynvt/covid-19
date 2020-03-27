import 'package:covid/service/service.dart';
import 'main_model.dart';

class MainLogic {
  final MainModel _model;

  MainLogic(this._model) {
    _loadData();
  }

  void _loadData() {
//    CountryService.shared().getListCountry();
  }

  void updateCountry(bool value) {
    _model.isWorld = value;
    _model.refresh();
  }
}
