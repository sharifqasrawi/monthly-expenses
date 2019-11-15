import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';
import './payment.dart';

class Payments with ChangeNotifier {
  List<Payment> _payments = [];

  String authToken;
  String userId;

  Payments(this.authToken, this.userId, this._payments);

  List<Payment> get payments {
    return [..._payments];
  }

  List<Payment> getPaymentsByMonthId(String id) {
    return _payments.where((p) => p.monthId == id).toList();
  }

  Future<void> fetchAndSetPayments() async {
    final url = 'https://monthly-expenses-d56f8.firebaseio.com/payments.json?auth=$authToken';
    try {
      final response = await http.get(url);

      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      final List<Payment> loadedPayments = [];
      if (extractedData == null) {
        return;
      }

      extractedData.forEach((paymentId, paymentData) {
        loadedPayments.add(Payment(
          id: paymentId,
          title: paymentData['title'],
          amount: paymentData['amount'],
          createdAt: DateTime.parse(paymentData['createdAt']),
          monthId: paymentData['monthId'],
        ));

        loadedPayments.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        _payments = loadedPayments.reversed.toList();
        notifyListeners();
      });
    } catch (error) {
      throw error;
    }
  }

  Future<void> addPayment(Payment payment) async {
    final url = 'https://monthly-expenses-d56f8.firebaseio.com/payments.json?auth=$authToken';
    try {
      final createdAt = DateTime.now();
      final response = await http.post(
        url,
        body: json.encode(
          {
            'amount': payment.amount,
            'monthId': payment.monthId,
            'title': payment.title,
            'createdAt': createdAt.toIso8601String(),
          },
        ),
      );

      final newPayment = Payment(
        id: json.decode(response.body)['name'],
        title: payment.title,
        amount: payment.amount,
        monthId: payment.monthId,
        createdAt: createdAt,
      );

      _payments.insert(0, newPayment);

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> deletePayment(String id) async {
    final url =
        'https://monthly-expenses-d56f8.firebaseio.com/payments/$id.json?auth=$authToken';

    final existingPaymentIndex = _payments.indexWhere((p) => p.id == id);
    var existingPayment = _payments[existingPaymentIndex];

    _payments.removeAt(existingPaymentIndex);
    notifyListeners();

    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _payments.insert(existingPaymentIndex, existingPayment);
      notifyListeners();
      throw HttpException(
          message: 'An Error occured while deleting this month');
    }
    existingPayment = null;
  }
}
