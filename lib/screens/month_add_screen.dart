import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/month.dart';
import '../providers/months.dart';
import '../widgets/drawer.dart';

class MonthAddScreen extends StatefulWidget {
  static const routeName = '/add-month';

  @override
  _MonthAddScreenState createState() => _MonthAddScreenState();
}

class _MonthAddScreenState extends State<MonthAddScreen> {
  var _isLoading = false;

  final _form = GlobalKey<FormState>();

  final _monthNameFocusNode = FocusNode();

  final _monthNumberFocusNode = FocusNode();

  final _amountFocusNode = FocusNode();

  var _month = Month(
    id: null,
    name: '',
    number: 0,
    amount: 0.0,
    amountLeft: 0.0,
    year: 0,
    createdAt: DateTime.now(),
  );

  var _initValues = {
    'year': DateTime.now().year.toString(),
    'monthName': DateFormat.MMMM().format(DateTime.now()),
    'monthNumber': DateTime.now().month.toString(),
  };

  @override
  void dispose() {
    _monthNameFocusNode.dispose();
    _monthNumberFocusNode.dispose();
    _amountFocusNode.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();

    try {
      _month = Month(
          id: _month.id,
          name: _month.name,
          number: _month.number,
          amount: _month.amount,
          amountLeft: _month.amountLeft,
          year: _month.year,
          createdAt: DateTime.now());

      if (Provider.of<Months>(context)
          .isMonthExists(_month.year, _month.number, false)) {
        await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: const Text('Error'),
                  content: const Text('This month already exists.'),
                  actions: <Widget>[
                    FlatButton(
                      child: const Text('Okay'),
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                    )
                  ],
                ));
        setState(() {
          _isLoading = false;
        });
        return;
      } else {
        setState(() {
          _isLoading = true;
        });
        await Provider.of<Months>(context, listen: false).addMonth(_month);
      }
    } catch (error) {
      await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: const Text('An Error Occured'),
                content: const Text('Sorry, something went wrong.'),
                actions: <Widget>[
                  FlatButton(
                    child: const Text('Okay'),
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                  )
                ],
              ));
      setState(() {
        _isLoading = false;
      });
    }
    Navigator.of(context).pushReplacementNamed('/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add new month'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _isLoading ? null : _saveForm,
            ),
          ],
        ),
        drawer: AppDrawer(),
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
            _isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Padding(
                    padding: const EdgeInsets.all(15),
                    child: Form(
                      key: _form,
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              decoration: InputDecoration(labelText: 'Year'),
                              initialValue: _initValues['year'],
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Year is required';
                                }
                                return null;
                              },
                              onFieldSubmitted: (_) {
                                FocusScope.of(context)
                                    .requestFocus(_monthNameFocusNode);
                              },
                              onSaved: (value) {
                                _month = Month(
                                  id: _month.id,
                                  name: _month.name,
                                  number: _month.number,
                                  amount: _month.amount,
                                  amountLeft: _month.amountLeft,
                                  year: int.parse(value),
                                  createdAt: _month.createdAt,
                                );
                              },
                            ),
                            TextFormField(
                              decoration:
                                  InputDecoration(labelText: 'Month Name'),
                              initialValue: _initValues['monthName'],
                              textInputAction: TextInputAction.next,
                              focusNode: _monthNameFocusNode,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Month name is required';
                                }
                                return null;
                              },
                              onFieldSubmitted: (_) {
                                FocusScope.of(context)
                                    .requestFocus(_monthNumberFocusNode);
                              },
                              onSaved: (value) {
                                _month = Month(
                                  id: _month.id,
                                  name: value,
                                  number: _month.number,
                                  amount: _month.amount,
                                  amountLeft: _month.amountLeft,
                                  year: _month.year,
                                  createdAt: _month.createdAt,
                                );
                              },
                            ),
                            TextFormField(
                              decoration:
                                  InputDecoration(labelText: 'Month Number'),
                              textInputAction: TextInputAction.next,
                              initialValue: _initValues['monthNumber'],
                              keyboardType: TextInputType.number,
                              focusNode: _monthNumberFocusNode,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Month number is required';
                                }
                                return null;
                              },
                              onFieldSubmitted: (_) {
                                FocusScope.of(context)
                                    .requestFocus(_amountFocusNode);
                              },
                              onSaved: (value) {
                                _month = Month(
                                  id: _month.id,
                                  name: _month.name,
                                  number: int.parse(value),
                                  amount: _month.amount,
                                  amountLeft: _month.amountLeft,
                                  year: _month.year,
                                  createdAt: _month.createdAt,
                                );
                              },
                            ),
                            TextFormField(
                              decoration: InputDecoration(labelText: 'Amount'),
                              textInputAction: TextInputAction.done,
                              keyboardType: TextInputType.number,
                              focusNode: _amountFocusNode,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Amount is required';
                                }
                                return null;
                              },
                              onFieldSubmitted: (_) {},
                              onSaved: (value) {
                                _month = Month(
                                  id: _month.id,
                                  name: _month.name,
                                  number: _month.number,
                                  amount: double.parse(value),
                                  amountLeft: double.parse(value),
                                  year: _month.year,
                                  createdAt: _month.createdAt,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
          ],
        ));
  }
}
