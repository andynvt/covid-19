import 'package:shared_preferences/shared_preferences.dart';

class CacheService {
  static CacheService _sInstance;
  SharedPreferences _service;

  CacheService._();

  factory CacheService.shared() {
    if (_sInstance == null) {
      _sInstance = CacheService._();
    }
    return _sInstance;
  }

  static Future init() async {
    return await CacheService.shared()._init();
  }

  Future _init() async {
    _service = await SharedPreferences.getInstance();
  }

  T _get<T>(String key) {
    final v = _service.get(key);
    if (v is T) return v;
    return null;
  }

  bool getBool(String key) {
    return _get<bool>(key) ?? false;
  }

  int getInt(String key) {
    return _get<int>(key) ?? 0;
  }

  double getDouble(String key) {
    return _get<double>(key) ?? 0;
  }

  String getString(String key) {
    return _get<String>(key) ?? "";
  }

  List<String> getListString(String key) {
    return _get<List<String>>(key) ?? [];
  }

  bool hasKey(String key) {
    return _service.containsKey(key);
  }

  void setBool(String key, bool value) {
    _service.setBool(key, value);
  }

  void setInt(String key, int value) {
    _service.setInt(key, value);
  }

  void setDouble(String key, double value) {
    _service.setDouble(key, value);
  }

  Future<bool> setString(String key, String value) {
    return _service.setString(key, value);
  }

  Future<bool> setListString(String key, List<String> value) {
    return _service.setStringList(key, value);
  }

  Future<bool> remove(String key) {
    return _service.remove(key);
  }

  Future<bool> clear() {
    return _service.clear();
  }

  Future<void> reload() {
    return _service.reload();
  }
}
