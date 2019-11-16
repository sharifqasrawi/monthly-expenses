import 'package:flutter/material.dart';


class Statistics extends StatelessWidget {
  static const routeName = '/stats';

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics'),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(255, 117, 155, 1).withOpacity(0.5),
                  Color.fromRGBO(255, 88, 17, 1).withOpacity(0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0, 1],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: SingleChildScrollView(
              child: Container(),
            ),
          )
        ],
      ),
    );
  }
}
