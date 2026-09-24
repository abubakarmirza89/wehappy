import 'package:flutter/material.dart';

TextStyle SafeGoogleFont(
  String fontFamily, {
  double? fontSize,
  FontWeight? fontWeight,
  double? height,
  Color? color,
}) {
  return TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSize,
    fontWeight: fontWeight,
    height: height,
    color: color,
  );
}
