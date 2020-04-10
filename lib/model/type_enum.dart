import 'package:covid/core/language/language.dart';
import 'package:covid/model/country_info.dart';
import 'package:covid/resource/resource.dart';
import 'package:covid/util/util.dart';
import 'package:flutter/material.dart';

enum TypeEnum { TOTAL, ACTIVE, RECOVERED, DEATH, CRITICAL, CASE_TODAY, DEATH_TODAY }

String typeEnumToStr(TypeEnum type) {
  switch (type) {
    case TypeEnum.TOTAL:
      return Language.get.total;
    case TypeEnum.ACTIVE:
      return Language.get.active;
    case TypeEnum.RECOVERED:
      return Language.get.recovered;
    case TypeEnum.DEATH:
      return Language.get.death;
    case TypeEnum.CRITICAL:
      return Language.get.critical;
    case TypeEnum.CASE_TODAY:
      return Language.get.case_today;
    case TypeEnum.DEATH_TODAY:
      return Language.get.death_today;
    default:
      return '';
  }
}

TypeEnum strToTypeEnum(String str) {
  switch (str) {
    case 'Total':
      return TypeEnum.TOTAL;
    case 'Active':
      return TypeEnum.ACTIVE;
    case 'Recovered':
      return TypeEnum.RECOVERED;
    case 'Death':
      return TypeEnum.DEATH;
    case 'Critical':
      return TypeEnum.CRITICAL;
    case 'Case today':
      return TypeEnum.CASE_TODAY;
    case 'Death today':
      return TypeEnum.DEATH_TODAY;
    default:
      return TypeEnum.TOTAL;
  }
}

String typeEnumToCasesStr(TypeEnum type, CountryInfo info) {
  switch (type) {
    case TypeEnum.TOTAL:
      return TTString.shared().formatNumber(info.cases);
    case TypeEnum.ACTIVE:
      return TTString.shared().formatNumber(info.active);
    case TypeEnum.RECOVERED:
      return TTString.shared().formatNumber(info.recovered);
    case TypeEnum.DEATH:
      return TTString.shared().formatNumber(info.deaths);
    case TypeEnum.CASE_TODAY:
      return TTString.shared().formatNumber(info.todayCases);
    case TypeEnum.DEATH_TODAY:
      return TTString.shared().formatNumber(info.todayDeaths);
    case TypeEnum.CRITICAL:
      return TTString.shared().formatNumber(info.critical);
    default:
      return '-';
  }
}

Color typeEnumToColor(TypeEnum type) {
  switch (type) {
    case TypeEnum.TOTAL:
      return Cl.orangeYellow;
    case TypeEnum.ACTIVE:
      return Cl.tealish;
    case TypeEnum.RECOVERED:
      return Cl.lightAqua;
    case TypeEnum.DEATH:
      return Cl.salmon;
    default:
      return Cl.black;
  }
}

TextStyle typeEnumToStyle(TypeEnum type) {
  switch (type) {
    case TypeEnum.TOTAL:
      return Style.ts_total_20;
    case TypeEnum.ACTIVE:
      return Style.ts_total_20;
    case TypeEnum.RECOVERED:
      return Style.ts_total_20;
    case TypeEnum.DEATH:
      return Style.ts_total_20;
    default:
      return Style.ts_total_18;
  }
}
