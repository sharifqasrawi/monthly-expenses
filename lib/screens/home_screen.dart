import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/months.dart';
import '../widgets/drawer.dart';
import 'months_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      Provider.of<Months>(context).fetchAndSetMonths(0);
    }

    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // final month = Provider.of<Months>(context, listen: false).getCurrentMonth();
    //print(month.name);

    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Monthly Expenses'),
      ),
      drawer: AppDrawer(),
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                    'https://www.diversebc.com.au/wp-content/uploads/2019/06/background-balance-commerce-583846.jpg'),
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
          ),
          Container(
            height: deviceSize.height,
            width: deviceSize.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // Flexible(
                //   child: Container(
                //     margin: const EdgeInsets.only(bottom: 10.0),
                //     padding: const EdgeInsets.symmetric(
                //         vertical: 9.0, horizontal: 54.0),
                //     transform: Matrix4.rotationZ(-8 * pi / 180)
                //       ..translate(0.0),
                //     decoration: BoxDecoration(
                //       borderRadius: BorderRadius.circular(20),
                //       color: Color.fromRGBO(45, 66, 156, 0.8),
                //       boxShadow: [
                //         BoxShadow(
                //           blurRadius: 8,
                //           color: Colors.black26,
                //           offset: Offset(0, 2),
                //         )
                //       ],
                //     ),
                //     child: Text(
                //       'My Monthly Expenses',
                //       style: TextStyle(
                //         color: Theme.of(context).accentTextTheme.title.color,
                //         fontSize: 24,
                //       ),
                //     ),
                //   ),
                // ),
                Flexible(
                  flex: deviceSize.width > 500 ? 2 : 1,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 8.0,
                    color: Color.fromRGBO(79, 97, 176, 0.9),
                    child: Container(
                      height: 300,
                      constraints: BoxConstraints(
                        minHeight: 300,
                      ),
                      width: deviceSize.width * 0.75,
                      padding: EdgeInsets.all(16.0),
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            Text(
                              'November',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold),
                            ),
                            Divider(
                              color: Colors.white,
                              thickness: 2,
                            ),
                            Text(
                              'Left: 320.00€',
                              style: TextStyle(
                                color: Colors.lime,
                                fontSize: 20,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Spent: 100.00€',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 20,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            RaisedButton(
                              child: Text(
                                'All Months',
                                style: TextStyle(color: Colors.white),
                              ),
                              color: Color.fromRGBO(128, 134, 158, 0.8),
                              onPressed: () {
                                Navigator.of(context).pushReplacementNamed(
                                    MonthsScreen.routeName);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
