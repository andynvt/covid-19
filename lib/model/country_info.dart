import 'package:covid/model/historical_info.dart';
import 'package:covid/model/model.dart';
import 'package:flutter/material.dart';

class CountryInfo extends ChangeNotifier {
  final String code;
  String name;
  int cases;
  int todayCases;
  int deaths;
  int todayDeaths;
  int recovered;
  int active;
  int critical;
  DateTime updated;
  double latitude;
  double longitude;
  HistoricalInfo historical;

//  final List<NewsInfo> news = [];

  CountryInfo(
      {this.name,
      this.code,
      this.cases,
      this.todayCases,
      this.deaths,
      this.todayDeaths,
      this.recovered,
      this.active,
      this.critical,
      this.updated,
      this.latitude,
      this.longitude,
      this.historical});

  factory CountryInfo.fromJson(Map<String, dynamic> json) {
    String name = 'Global';
    String code = '';
    double lat = 0.0;
    double long = 0.0;
    if (json['countryInfo'] != null) {
      name = json['country'];
      code = json['countryInfo']['iso2'];
      lat = (json['countryInfo']['lat']).toDouble();
      long = (json['countryInfo']['long']).toDouble();
    }
    return CountryInfo(
      name: name,
      code: code,
      cases: json['cases'],
      todayCases: json['todayCases'],
      deaths: json['deaths'],
      todayDeaths: json['todayDeaths'],
      recovered: json['recovered'],
      active: json['active'],
      critical: json['critical'],
      updated: DateTime.fromMillisecondsSinceEpoch(json['updated']),
      latitude: lat,
      longitude: long,
    );
  }

  int getPropertyByTypeEnum(TypeEnum type) {
    switch (type) {
      case TypeEnum.TOTAL:
        return cases;
      case TypeEnum.ACTIVE:
        return active;
      case TypeEnum.RECOVERED:
        return recovered;
      case TypeEnum.DEATH:
        return deaths;
      case TypeEnum.CRITICAL:
        return critical;
      case TypeEnum.CASE_TODAY:
        return todayCases;
      case TypeEnum.DEATH_TODAY:
        return todayDeaths;
      default:
        return -1;
    }
  }
}
