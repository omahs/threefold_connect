import 'dart:ui';

Color _colorFromHex(String hexColor) {
  final hexCode = hexColor.replaceAll('#', '');
  return Color(int.parse('FF$hexCode', radix: 16));
}

Color kThreeFoldGreenColor = _colorFromHex('57BE8E');
Color kAppBarColor = _colorFromHex('0a73b8');
Color kErrorColor = _colorFromHex('FF0000');
Color kTextColor = _colorFromHex('000000');
