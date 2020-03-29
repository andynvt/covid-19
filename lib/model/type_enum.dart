import 'package:covid/resource/resource.dart';
import 'package:flutter/material.dart';

enum TypeEnum { CONFIRMED, RECOVERED, DEATH, CRITICAL, CASE_TODAY, DEATH_TODAY }

String typeEnumToStr(TypeEnum type) {
  switch (type) {
    case TypeEnum.CONFIRMED:
      return 'Confirmed';
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
    case TypeEnum.CONFIRMED:
      return Cl.lightBlue;
    case TypeEnum.RECOVERED:
      return Cl.shamrockGreen;
    case TypeEnum.DEATH:
      return Cl.rustyRed;
    case TypeEnum.CRITICAL:
      return Cl.pinkRed;
    case TypeEnum.CASE_TODAY:
      return Cl.lightBlue;
    case TypeEnum.DEATH_TODAY:
      return Cl.rustyRed;
    default:
      return Cl.black;
  }
}

TextStyle typeEnumToStyle(TypeEnum type) {
  switch (type) {
    case TypeEnum.CONFIRMED:
      return Style.ts_13_blue;
    case TypeEnum.RECOVERED:
      return Style.ts_13_green;
    case TypeEnum.DEATH:
      return Style.ts_13_red;
    case TypeEnum.CRITICAL:
      return Style.ts_13_black;
    case TypeEnum.CASE_TODAY:
      return Style.ts_13_black;
    case TypeEnum.DEATH_TODAY:
      return Style.ts_13_black;
    default:
      return Style.ts_13_black;
  }
}
