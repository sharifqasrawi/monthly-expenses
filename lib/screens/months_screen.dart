import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/months.dart';
import '../providers/settings.dart';
import '../widgets/drawer.dart';
import '../widgets/months_list.dart';

class MonthsScreen extends StatefulWidget {
  static const routeName = '/months';

  @override
  _MonthsScreenState createState() => _MonthsScreenState();
}

class _MonthsScreenState extends State<MonthsScreen> {
  var _currentYear = 1;
  var currency = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Monthly Expenses'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (selectedValue) {
              setState(() {
                _currentYear = selectedValue;
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text(DateTime.now().year.toString()),
                value: 1,
              ),
              PopupMenuItem(
                child: const Text('All Years'),
                value: 0,
              ),
            ],
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg.png'),
            fit: BoxFit.cover,
          ),
          // gradient: LinearGradient(
          //   colors: [
          //     Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
          //     Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
          //   ],
          //   begin: Alignment.topLeft,
          //   end: Alignment.bottomRight,
          //   stops: [0, 1],
          // ),
        ),
        child: RefreshIndicator(
          onRefresh: () => Provider.of<Months>(context, listen: false)
              .fetchAndSetMonths(_currentYear),
          child: FutureBuilder(
            future: Provider.of<Months>(context, listen: false)
                .fetchAndSetMonths(_currentYear),
            builder: (ctx, dataSnapshot) {
              if (dataSnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                if (dataSnapshot.error != null) {
                  return Center(
                    child: Text(
                      'Error loading data',
                      style: TextStyle(color: Theme.of(context).errorColor),
                    ),
                  );
                } else {
                  Timer.periodic(
                      Duration(milliseconds: 500),
                      (t) => Provider.of<Months>(context, listen: false)
                          .fetchAndSetMonths(_currentYear));
                  currency = Provider.of<Settings>(context, listen: false)
                      .getSettingValue('currency');
                  return Consumer<Months>(
                    builder: (ctx, monthData, child) =>
                        MonthsList(currency: currency),
                  );
                }
              }
            },
          ),
        ),
      ),
      drawer: AppDrawer(),
    );
  }
}
