import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import './screens/months_screen.dart';
import './screens/payments.screen.dart';
import './screens/month_add_screen.dart';
import './screens/month_update_screen.dart';
import './screens/home_screen.dart';
import './screens/splash_screen.dart';
import './screens/auth_screen.dart';
import './providers/months.dart';
import './providers/payments.dart';
import './providers/auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Months>(
          builder: (ctx, auth, prevMonths) => Months(
            auth.token,
            auth.userId,
            prevMonths == null ? [] : prevMonths.items,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, Payments>(
          builder: (ctx, auth, prevPayments) => Payments(
            auth.token,
            auth.userId,
            prevPayments == null ? [] : prevPayments.payments,
          ),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Monthly Expenses',
          theme: ThemeData(
            fontFamily: 'Raleway',
            primarySwatch: Colors.deepOrange,
            accentColor: Colors.deepPurpleAccent,
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
          home: auth.isAuth
              ? HomeScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
          routes: {
            MonthsScreen.routeName: (_) => MonthsScreen(),
            PaymentsScreen.routeName: (_) => PaymentsScreen(),
            MonthAddScreen.routeName: (_) => MonthAddScreen(),
            MonthUpdateScreen.routeName: (_) => MonthUpdateScreen(),
          },
        ),
      ),
    );
  }
}
