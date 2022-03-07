import 'package:flutter/material.dart';

extension ColorExtension on Color {

  String toHexString() {
    return '#${value.toRadixString(16)}';
  }

}