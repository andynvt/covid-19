//import 'dart:math';
//
//import 'package:flutter/material.dart';
//import 'package:charts_flutter/flutter.dart';
//import 'package:charts_flutter/src/text_element.dart' as element;
//import 'package:charts_flutter/src/text_style.dart' as style;
//
//import 'main_view.dart';
//
//class CustomCircleSymbolRenderer extends CircleSymbolRenderer {
//  @override
//  void paint(ChartCanvas canvas, Rectangle<num> bounds,
//      {List<int> dashPattern,
//      Color fillColor,
//      FillPatternType fillPattern,
//      Color strokeColor,
//      double strokeWidthPx}) {
//    super.paint(canvas, bounds,
//        dashPattern: dashPattern,
//        fillColor: fillColor,
//        strokeColor: strokeColor,
//        strokeWidthPx: strokeWidthPx);
//    canvas.drawRect(
//        Rectangle(bounds.left - 5, bounds.top - 30, bounds.width + 10,
//            bounds.height + 10),
//        fill: Color.white);
//    var textStyle = style.TextStyle();
//    textStyle.color = Color.black;
//    textStyle.fontSize = 15;
//    canvas.drawText(
//      element.TextElement('1', style: textStyle),
//      (bounds.left).round(),
//      (bounds.top - 28).round(),
//    );
//  }
//}

import 'package:flutter/material.dart';

class TooltipShapeBorder extends ShapeBorder {
  final double arrowWidth;
  final double arrowHeight;
  final double arrowArc;
  final double radius;

  TooltipShapeBorder({
    this.radius = 16.0,
    this.arrowWidth = 20.0,
    this.arrowHeight = 10.0,
    this.arrowArc = 0.0,
  }) : assert(arrowArc <= 1.0 && arrowArc >= 0.0);

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.only(bottom: arrowHeight);

  @override
  Path getInnerPath(Rect rect, {TextDirection textDirection}) => null;

  @override
  Path getOuterPath(Rect rect, {TextDirection textDirection}) {
    rect = Rect.fromPoints(rect.topLeft, rect.bottomRight - Offset(0, arrowHeight));
    double x = arrowWidth, y = arrowHeight, r = 1 - arrowArc;
    return Path()
      ..addRRect(RRect.fromRectAndRadius(rect, Radius.circular(radius)))
      ..moveTo(rect.bottomCenter.dx + x / 2, rect.bottomCenter.dy)
      ..relativeLineTo(-x / 2 * r, y * r)
      ..relativeQuadraticBezierTo(-x / 2 * (1 - r), y * (1 - r), -x * (1 - r), 0)
      ..relativeLineTo(-x / 2 * r, -y * r);
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection textDirection}) {}

  @override
  ShapeBorder scale(double t) => this;
}
