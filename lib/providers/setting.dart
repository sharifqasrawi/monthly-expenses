import 'package:flutter/foundation.dart';

class Setting {
  final String setTitle;
  final String setValue;

  static const List<String> cureencies = [
    '€',
    '\$',
    '£',
  ];

  Setting({
    @required this.setTitle,
    @required this.setValue,
  });
}
