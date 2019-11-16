import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/auth.dart';
import '../screens/month_add_screen.dart';
import '../screens/months_screen.dart';
import '../screens/settings_screen.dart';
//import '../screens/statistics_screen.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  var email = '';
  var _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      Future.delayed(Duration.zero).then((_) async {
        var prefs = await SharedPreferences.getInstance();
        if (prefs.containsKey('userData')) {
          final extractedUserData =
              json.decode(prefs.getString('userData')) as Map<String, Object>;

          setState(() {
            email = extractedUserData['email'];
          });
        }
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Color.fromRGBO(255, 187, 143, 1),
        child: ListView(
          children: <Widget>[
            AppBar(
              title: Row(
                children: [
                  Icon(Icons.supervisor_account),
                  Text(
                    ' $email',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              automaticallyImplyLeading: false,
            ),
            Divider(),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.of(context).pushReplacementNamed('/');
              },
            ),
            Divider(),
            ListTile(
              leading: const Icon(Icons.calendar_view_day),
              title: const Text('All Months'),
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(MonthsScreen.routeName);
              },
            ),
            Divider(),
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Add Month'),
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(MonthAddScreen.routeName);
              },
            ),
            // Divider(),
            // ListTile(
            //   leading: Icon(Icons.insert_chart),
            //   title: const Text('Statistics'),
            //   onTap: () {
            //     Navigator.of(context).pop();
            //     Navigator.of(context).pushNamed(Statistics.routeName);
            //   },
            // ),
            Divider(),
            ListTile(
              leading: Icon(Icons.settings_applications),
              title: const Text('Settings'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context)
                    .pushNamed(SettingsScreen.routeName);
              },
            ),
            Divider(),
            AboutListTile(
              icon: const Icon(Icons.info),
              child: const Text('About'),
              applicationName: 'Monthly Expenses',
              applicationLegalese: 'Developed by Sharif Qasrawi',
              applicationVersion: 'V.1.0.0',
              applicationIcon: Image.asset(
                'dev_assets/icon.png',
                width: 50,
                height: 50,
              ),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: const Text('Logout'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed('/');

                // Navigator.of(context)
                //     .pushReplacementNamed(UserProductsScreen.routeName);
                Provider.of<Auth>(context, listen: false).logout();
              },
            ),
          ],
        ),
      ),
    );
  }
}
