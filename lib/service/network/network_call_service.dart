import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../service.dart';

class NetworkService extends BaseService {
  static NetworkService _sInstance;

  Map<String, String> _headers = {};

  NetworkService._();

  factory NetworkService.shared() {
    if (_sInstance == null) {
      _sInstance = NetworkService._();
    }
    return _sInstance;
  }

  void addHeader(String key, String value) {
    _headers[key] = value;
  }

  void sendGETRequest(
      {@required String url,
      Map<String, dynamic> params,
      ParseCallback parser,
      Map<String, String> headers,
      NetworkCallback callback}) {
    assert(url != null);

    if (headers == null) {
      headers = _headers;
    }

    url = _buildRequestParams(url, params);
    if (d___) {
      print('--> Get URL: $url');
    }
    http.get(url, headers: headers).then((result) {
      if (result.statusCode == 200) {
        _getResponse(true, result.body, callback, parser: parser);
      } else {
        _getResponse(false, _getMsgError(result.statusCode), callback);
      }
    }, onError: (e) {
      _getResponse(false, e.message, callback);
    });
  }

  void sendPOSTRequest(
      {@required String url,
      Map<String, dynamic> params,
      ParseCallback parser,
      Map<String, String> headers,
      NetworkCallback callback}) {
    assert(url != null);
    if (headers == null) {
      headers = {};
    }

    url = _buildRequestParams(url, params);
    if (d___) {
      print('--> Post URL: $url');
    }
    http.post(url, headers: _headers).then((result) {
      if (result.statusCode == 200) {
        _getResponse(true, result.body, callback, parser: parser);
      } else {
        _getResponse(false, _getMsgError(result.statusCode), callback);
      }
    }, onError: (e) {
      _getResponse(false, e.toString(), callback);
    });
  }

  void _getResponse(bool isOK, String data, NetworkCallback callback,
      {ParseCallback parser}) {
    if (d___) {
      print('--> Data from response: \n$data');
    }
    if (isOK && callback != null) {
      final _data = jsonDecode(data);
      final dt = parser != null ? parser(_data) : _data;
      callback(TTNetworkCallback(isOK: true, data: dt));
    } else {
      if (callback != null) {
        callback(TTNetworkCallback(isOK: false, msgError: data));
      }
    }
  }

  String _buildRequestParams(String url, Map<String, dynamic> params) {
    if (params == null || params.isEmpty) {
      return url;
    }
    final p = params.keys.toList().map((key) {
      return '$key=${params[key]}';
    }).toList();
    return '$url?${p.join('&')}';
  }

  String _getMsgError(int id) {
    switch (id) {
      case 500:
        return '$id - Internal server error';
    }
    return 'Unknow Error';
  }
}
