import 'root_model.dart';


class RootLogic {
  RootModel _model;

  RootLogic(this._model);

  void showLoading(String key) {
    if (_model.isLoading.value) {
      return;
    }
    _model.isLoading.add(true);
    _model.loadingKey = key;
  }

  void hideLoading(String key) {
    if (!_model.isLoading.value ||
        key != _model.loadingKey ||
        _model.loadingKey.isEmpty) {
      return;
    }
    _model.isLoading.add(false);
    _model.loadingKey = key;
  }
}
