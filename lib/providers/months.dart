import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './month.dart';
import '../models/http_exception.dart';

class Months with ChangeNotifier {
  List<Month> _items = [];

  String authToken;
  String userId;

  Months(
    this.authToken,
    this.userId,
    this._items,
  );

  List<Month> get items {
    return [..._items].reversed.toList();
  }

  Month findById(String id) {
    return _items.firstWhere((m) => m.id == id);
  }

  bool isMonthExists(int year, int number, bool _isUpdating) {
    // if (!_isUpdating) {
    //   final month = _items.any((m) => m.year == year && m.number == number);
    //   if (month != null) {
    //     return true;
    //   }
    //   return false;
    // } else {
    //   return false;
    // }
    return false;
  }

  Future<void> fetchAndSetMonths(int currentYear) async {
    final url =
        'https://monthly-expenses-d56f8.firebaseio.com/months.json?auth=$authToken&orderBy="userId"&equalTo="$userId"';

    try {
      final response = await http.get(url);

      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      final List<Month> loadedMonths = [];

      if (extractedData == null) {
        return;
      }

      extractedData.forEach((id, data) {
        if (id == 'error') {
          print('Error in fetch');
          return;
        }
        loadedMonths.add(
          Month(
            id: id,
            name: data['monthName'],
            number: data['monthNumber'],
            amount: data['amount'],
            amountLeft: data['amountLeft'],
            year: data['year'],
            createdAt: DateTime.parse(data['createdAt']),
          ),
        );
      });

      if (currentYear == 1) {
        _items =
            loadedMonths.where((m) => m.year == DateTime.now().year).toList();
        _items.sort((a, b) => a.number.compareTo(b.number));
      } else {
        loadedMonths.sort((a, b) => a.number.compareTo(b.number));
        loadedMonths.sort((a, b) => a.year.compareTo(b.year));
        _items = loadedMonths;
      }
      //print(loadedMonths.length);

      notifyListeners();
    } catch (error) {
      //print('error here');
      throw error;
    }
  }

  Future<void> addMonth(Month month) async {
    try {
      final url =
          'https://monthly-expenses-d56f8.firebaseio.com/months.json?auth=$authToken';

     // month.userId = userId;

      if (isMonthExists(month.year, month.number, false)) {
        return;
      }
      final createdAt = DateTime.now();
      final response = await http.post(
        url,
        body: json.encode({
          'year': month.year,
          'monthName': month.name,
          'monthNumber': month.number,
          'amount': month.amount,
          'amountLeft': month.amount,
          'createdAt': createdAt.toIso8601String(),
          'userId': userId,
        }),
      );

      final newMonth = Month(
        id: json.decode(response.body)['name'],
        name: month.name,
        number: month.number,
        amount: month.amount,
        amountLeft: month.amount,
        year: month.year,
        createdAt: createdAt,
      );

      _items.add(newMonth);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateMonth(String id, Month newMonth) async {
    final monthIndex = _items.indexWhere((m) => m.id == id);
    try {
      final url =
          'https://monthly-expenses-d56f8.firebaseio.com/months/$id.json?auth=$authToken';
      if (isMonthExists(newMonth.year, newMonth.number, true)) {
        return;
      }

      if (monthIndex >= 0) {
        final month = _items.firstWhere((m) => m.id == id);

        await http.patch(
          url,
          body: json.encode(
            {
              'monthName': newMonth.name,
              'monthNumber': newMonth.number,
              'year': newMonth.year,
              'amount': newMonth.amount,
              'amountLeft': month.amountLeft + (newMonth.amount - month.amount),
            },
          ),
        );
        _items[monthIndex] = newMonth;
      }
    } catch (error) {
      throw error;
    }
    notifyListeners();
  }

  Future<void> updateAmountLeft({String monthId, double amount}) async {
    final url =
        'https://monthly-expenses-d56f8.firebaseio.com/months/$monthId.json?auth=$authToken';

    final monthIndex = _items.indexWhere((m) => m.id == monthId);
    try {
      if (monthIndex >= 0) {
        final month = _items[monthIndex];
        final newMonth = Month(
          id: month.id,
          year: month.year,
          name: month.name,
          number: month.number,
          createdAt: month.createdAt,
          amount: month.amount,
          amountLeft: month.amountLeft - amount,
        );

        await http.patch(
          url,
          body: json.encode({
            'amountLeft': newMonth.amountLeft,
          }),
        );
        _items[monthIndex] = newMonth;
      }
    } catch (error) {
      throw error;
    }

    notifyListeners();
  }

  Future<void> deleteMonth(String id) async {
    final url =
        'https://monthly-expenses-d56f8.firebaseio.com/months/$id.json?auth=$authToken';

    final existingMonthIndex = _items.indexWhere((m) => m.id == id);
    var existingMonth = _items[existingMonthIndex];

    _items.removeAt(existingMonthIndex);
    notifyListeners();

    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingMonthIndex, existingMonth);
      notifyListeners();
      throw HttpException(
          message: 'An Error occured while deleting this month');
    }
    existingMonth = null;
  }

  Month getCurrentMonth() {
    final curMonth = DateTime.now().month;
    final curYear = DateTime.now().year;
    final currentMonth = _items.firstWhere(
        (m) => m.year == curYear && m.number == curMonth,
        orElse: () => null);

    return currentMonth;
  }
}
