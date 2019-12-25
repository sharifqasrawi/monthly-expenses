import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//import 'package:firebase_admob/firebase_admob.dart';

import './screens/months_screen.dart';
import './screens/payments.screen.dart';
import './screens/month_add_screen.dart';
import './screens/month_update_screen.dart';
import './screens/home_screen.dart';
import './screens/splash_screen.dart';
import './screens/auth_screen.dart';
import './screens/settings_screen.dart';
import './screens/statistics_screen.dart';
import './providers/months.dart';
import './providers/payments.dart';
import './providers/auth.dart';
import './providers/settings.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    // FirebaseAdMob.instance.initialize(appId: 'ca-app-pub-3940256099942544/6300978111').then((response){
    //   myBanner..load()..show();
    // });  

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
        ChangeNotifierProxyProvider<Auth, Settings>(
          builder: (ctx, auth, prevSettings) => Settings(
            auth.token,
            auth.userId,
            prevSettings == null ? [] : prevSettings.settings,
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
            SettingsScreen.routeName: (_) => SettingsScreen(),
            Statistics.routeName: (_) =>Statistics(),
          },
        ),
      ),
    );
  }
}

// MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
//   keywords: <String>['expenses', 'monthly', 'money', 'calculator'],
//   contentUrl: 'https://flutter.io',
  
//   childDirected: false,
//  // or MobileAdGender.female, MobileAdGender.unknown
//   testDevices: <String>[], // Android emulators are considered test devices
// );

// BannerAd myBanner = BannerAd(
//   // Replace the testAdUnitId with an ad unit id from the AdMob dash.
//   // https://developers.google.com/admob/android/test-ads
//   // https://developers.google.com/admob/ios/test-ads
//   adUnitId: 'ca-app-pub-9231304976128778/9472186217',
//   size: AdSize.smartBanner,
//   targetingInfo: targetingInfo,
//   listener: (MobileAdEvent event) {
//     print("BannerAd event is $event");
//   },
// );