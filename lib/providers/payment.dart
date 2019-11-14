import 'package:flutter/foundation.dart';


class Payment with ChangeNotifier {
  final String id;
  final String title;
  final double amount;
  final DateTime createdAt;
  final String monthId;

  Payment({
    @required this.id,
    @required this.amount,
    @required this.createdAt,
    @required this.monthId,
    @required this.title
  });
}
