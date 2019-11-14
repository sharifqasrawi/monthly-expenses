import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/months_screen.dart';
import './screens/payments.screen.dart';
import './screens/month_add_screen.dart';
import './screens/month_update_screen.dart';
import './screens/home_screen.dart';
import './providers/months.dart';
import './providers/payments.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Months(),
        ),
        ChangeNotifierProvider.value(
          value: Payments(),
        ),
      ],
      child: MaterialApp(
        title: 'Monthly Expenses',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.pinkAccent,
          textTheme: ThemeData.light().textTheme.copyWith(
                title: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                button: TextStyle(
                  color: Colors.white,
                ),
              ),
          appBarTheme: AppBarTheme(
              textTheme: ThemeData.light().textTheme.copyWith(
                    title: TextStyle(
                      fontSize: 22,
                    ),
                  )),
        ),
        home: HomeScreen(),
        routes: {
          MonthsScreen.routeName: (_) => MonthsScreen(),
          PaymentsScreen.routeName: (_) => PaymentsScreen(),
          MonthAddScreen.routeName: (_) => MonthAddScreen(),
          MonthUpdateScreen.routeName: (_) => MonthUpdateScreen(),
        },
      ),
    );
  }
}
