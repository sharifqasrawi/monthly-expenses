import 'package:flutter/foundation.dart';

class Month with ChangeNotifier {
  final String id;
  final String name;
  final int number;
  final double amount;
  final double amountLeft;
  final int year;
  final DateTime createdAt;

  Month({
    @required this.id,
    @required this.name,
    @required this.number,
    @required this.amount,
    @required this.amountLeft,
    @required this.createdAt,
    @required this.year,
  });
}
