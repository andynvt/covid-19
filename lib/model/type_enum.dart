import 'package:covid/resource/resource.dart';
import 'package:flutter/material.dart';

enum TypeEnum { CASES, RECOVERED, DEATH, CRITICAL, CASE_TODAY, DEATH_TODAY }

String typeEnumToStr(TypeEnum type) {
  switch (type) {
    case TypeEnum.CASES:
      return 'Cases';
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
    case TypeEnum.CASES:
      return Cl.mBlue;
    case TypeEnum.RECOVERED:
      return Cl.mGreen;
    case TypeEnum.DEATH:
      return Cl.mRed;
    case TypeEnum.CRITICAL:
      return Cl.mBlueGrey;
    case TypeEnum.CASE_TODAY:
      return Cl.mBlueGrey;
    case TypeEnum.DEATH_TODAY:
      return Cl.mBlueGrey;
    default:
      return Cl.mBlueGrey;
  }
}
