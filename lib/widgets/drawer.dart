import 'package:flutter/material.dart';

import '../screens/month_add_screen.dart';
import '../screens/months_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Color.fromRGBO(255, 187, 143, 1),
        child: Column(
          children: <Widget>[
            AppBar(
              title: const Text('Hello !!'),
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
                Navigator.of(context).pushReplacementNamed(MonthsScreen.routeName);
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
          ],
        ),
      ),
    );
  }
}
