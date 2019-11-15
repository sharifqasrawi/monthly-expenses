//import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/month.dart';
import '../providers/months.dart';
import '../widgets/drawer.dart';
import './month_add_screen.dart';
//import './months_screen.dart';
import './payments.screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _isInit = true;
  var _isLoading = false;
  var monthName;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Months>(context, listen: false)
          .fetchAndSetMonths(1)
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }

    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Month month;
    if (!_isLoading) {
      month = Provider.of<Months>(context, listen: false).getCurrentMonth();
    }

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
                  child: _isLoading
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          elevation: 8.0,
                          color: Color.fromRGBO(240, 147, 86, 0.9),
                          child: Container(
                            height: 320,
                            constraints: BoxConstraints(
                              minHeight: 320,
                            ),
                            width: deviceSize.width * 0.75,
                            padding: EdgeInsets.all(16.0),
                            child: SingleChildScrollView(
                              child: month == null
                                  ? Container(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          SizedBox(
                                            height: 70,
                                          ),
                                          Text(
                                            'NO MONTHS REGISTERD YET',
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          RaisedButton(
                                            child: Text(
                                              'ADD MONTH NOW',
                                            ),
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .pushReplacementNamed(
                                                      MonthAddScreen.routeName);
                                            },
                                          ),
                                        ],
                                      ),
                                    )
                                  : Column(
                                      children: <Widget>[
                                        Text(
                                          '${month.name}',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 26,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Text(
                                          'Today: ${DateFormat("EEEE dd/MM/yyyy").format(DateTime.now())}',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                          ),
                                        ),
                                        Divider(
                                          color: Colors.white,
                                          thickness: 2,
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          'Left: ${month.amountLeft.toStringAsFixed(2)}€',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 24,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          'Spent: ${(month.amount - month.amountLeft).toStringAsFixed(2)}€',
                                          style: TextStyle(
                                            color: Colors.lime,
                                            fontSize: 22,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          'Income: ${month.amount.toStringAsFixed(2)}€',
                                          style: TextStyle(
                                            color: Colors.white38,
                                            fontSize: 22,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        RaisedButton(
                                          child: Text(
                                            'Add Payment',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          color: Color.fromRGBO(
                                              128, 134, 158, 0.8),
                                          onPressed: () {
                                            Navigator.of(context).pushNamed(
                                              PaymentsScreen.routeName,
                                              arguments: month.id,
                                            );
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
