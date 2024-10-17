import 'package:flutter/material.dart';

const magenta = Color(0xFFFF00FF);
const orchid = Color(0xFFDA70D6);
const fuchsia = Color(0xFFFF77FF);
const paleBlueGray = Color(0xFFD5DEE7);

Color checkBusColor(String? busType) {
  if (busType == '일반버스' || busType == '심야버스(일반)' || busType == '좌석버스(용원)') {
    return Colors.blue;
  } else if (busType == '마을버스') {
    return Colors.green;
  } else {
    return Colors.red;
  }
}
