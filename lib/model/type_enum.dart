import 'package:covid/resource/resource.dart';
import 'package:flutter/material.dart';

enum TypeEnum { TOTAL, ACTIVE, RECOVERED, DEATH, CRITICAL, CASE_TODAY, DEATH_TODAY }

String typeEnumToStr(TypeEnum type) {
  switch (type) {
    case TypeEnum.TOTAL:
      return 'Total';
    case TypeEnum.ACTIVE:
      return 'Active';
    case TypeEnum.RECOVERED:
      return 'Recovered';
    case TypeEnum.DEATH:
      return 'Death';
    case TypeEnum.CRITICAL:
      return 'Critical';
    case TypeEnum.CASE_TODAY:
      return 'Case today';
    case TypeEnum.DEATH_TODAY:
      return 'Death today';
    default:
      return '';
  }
}

Color typeEnumToColor(TypeEnum type) {
  switch (type) {
    case TypeEnum.TOTAL:
      return Cl.mBlue;
    case TypeEnum.ACTIVE:
      return Cl.mCyan;
    case TypeEnum.RECOVERED:
      return Cl.shamrockGreen;
    case TypeEnum.DEATH:
      return Cl.mRed;
    default:
      return Cl.black;
  }
}

TextStyle typeEnumToStyle(TypeEnum type) {
  switch (type) {
    case TypeEnum.TOTAL:
      return Style.ts_total;
    case TypeEnum.ACTIVE:
      return Style.ts_active;
    case TypeEnum.RECOVERED:
      return Style.ts_recovered;
    case TypeEnum.DEATH:
      return Style.ts_death;
    default:
      return Style.ts_13_black;
  }
}
