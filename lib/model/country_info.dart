import 'package:flutter/material.dart';

class CountryInfo extends ChangeNotifier {
  final int id;
  final String name;
  final String code;
  String flag;
  int cases;
  int todayCases;
  int deaths;
  int todayDeaths;
  int recovered;
  int active;
  int critical;
  double latitude;
  double longitude;

  CountryInfo(
      {this.id,
      this.name,
      this.code,
      this.flag,
      this.cases,
      this.todayCases,
      this.deaths,
      this.todayDeaths,
      this.recovered,
      this.active,
      this.critical,
      this.latitude,
      this.longitude});

  factory CountryInfo.fromJson(Map<String, dynamic> json) {
    return CountryInfo(
      id: json['countryInfo']['_id'],
      name: json['country'],
      code: json['countryInfo']['iso2'],
      flag: json['countryInfo']['flag'],
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
}
