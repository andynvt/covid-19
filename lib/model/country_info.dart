import 'package:covid/model/historical_info.dart';
import 'package:covid/model/model.dart';
import 'package:covid/module/main/main_model.dart';
import 'package:flutter/material.dart';

class CountryInfo extends ChangeNotifier {
  final int id;
  final String name;
  final String code;
  int cases;
  int todayCases;
  int deaths;
  int todayDeaths;
  int recovered;
  int active;
  int critical;
  double latitude;
  double longitude;
  HistoricalInfo historical;
//  final List<NewsInfo> news = [];

  CountryInfo(
      {this.id,
      this.name,
      this.code,
      this.cases,
      this.todayCases,
      this.deaths,
      this.todayDeaths,
      this.recovered,
      this.active,
      this.critical,
      this.latitude,
      this.longitude,
      this.historical});

  factory CountryInfo.fromJson(Map<String, dynamic> json) {
    return CountryInfo(
      id: json['countryInfo']['_id'],
      name: json['country'],
      code: json['countryInfo']['iso2'],
      cases: json['cases'],
      todayCases: json['todayCases'],
      deaths: json['deaths'],
      todayDeaths: json['todayDeaths'],
      recovered: json['recovered'],
      active: json['active'],
      critical: json['critical'],
      latitude: (json['countryInfo']['lat']).toDouble(),
      longitude: (json['countryInfo']['long']).toDouble(),
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
