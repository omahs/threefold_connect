import 'package:flutter/material.dart';
import 'package:threebotlogin/core/styles/color.styles.dart';

TextStyle? kConnectedTextStyle() {
  return TextStyle(color: kConnectedColor, fontWeight: FontWeight.bold, fontSize: 16);
}

TextStyle? kDisconnectedTextStyle() {
  return TextStyle(color: kErrorColor, fontWeight: FontWeight.bold, fontSize: 16);
}

TextStyle? kConnectingTextStyle() {
  return TextStyle(color: kConnectingColor, fontWeight: FontWeight.bold, fontSize: 16);
}

TextStyle? kTitle() {
  return TextStyle(fontSize: 24, fontWeight: FontWeight.bold);
}