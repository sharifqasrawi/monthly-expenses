import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/month.dart';
import '../providers/months.dart';

class MonthUpdateScreen extends StatefulWidget {
  static const routeName = '/update-month';

  @override
  _MonthUpdateScreenState createState() => _MonthUpdateScreenState();
}

class _MonthUpdateScreenState extends State<MonthUpdateScreen> {
  var _isLoading = false;
  var _isInit = true;
  final _form = GlobalKey<FormState>();

  final _monthNameFocusNode = FocusNode();

  final _monthNumberFocusNode = FocusNode();

  final _amountFocusNode = FocusNode();

  var _editedMonth = Month(
    id: null,
    name: '',
    number: 0,
    amount: 0.0,
    amountLeft: 0.0,
    year: 0,
    createdAt: DateTime.now(),
  );

  var _initValues = {'name': '', 'number': '', 'year': '', 'amount': ''};

  @override
  void dispose() {
    _monthNameFocusNode.dispose();
    _monthNumberFocusNode.dispose();
    _amountFocusNode.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final monthId = ModalRoute.of(context).settings.arguments as String;
      if (monthId != null) {
        _editedMonth =
            Provider.of<Months>(context, listen: false).findById(monthId);

        _initValues = {
          'name': _editedMonth.name,
          'number': _editedMonth.number.toString(),
          'year': _editedMonth.year.toString(),
          'amount': _editedMonth.amount.toStringAsFixed(2),
        };
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();

    try {
      _editedMonth = Month(
          id: _editedMonth.id,
          name: _editedMonth.name,
          number: _editedMonth.number,
          amount: _editedMonth.amount,
          amountLeft: _editedMonth.amountLeft,
          year: _editedMonth.year,
          createdAt: DateTime.now());

      if (Provider.of<Months>(context)
          .isMonthExists(_editedMonth.year, _editedMonth.number, true)) {
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
        await Provider.of<Months>(context, listen: false)
            .updateMonth(_editedMonth.id, _editedMonth);
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
    final monthId = ModalRoute.of(context).settings.arguments as String;
    final month = Provider.of<Months>(context).findById(monthId);

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit month: ${month.name}'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _isLoading ? null : _saveForm,
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
                  Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
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
                              _editedMonth = Month(
                                id: _editedMonth.id,
                                name: _editedMonth.name,
                                number: _editedMonth.number,
                                amount: _editedMonth.amount,
                                amountLeft: _editedMonth.amountLeft,
                                year: int.parse(value),
                                createdAt: _editedMonth.createdAt,
                              );
                            },
                          ),
                          TextFormField(
                            decoration:
                                InputDecoration(labelText: 'Month Name'),
                            initialValue: _initValues['name'],
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
                              _editedMonth = Month(
                                id: _editedMonth.id,
                                name: value,
                                number: _editedMonth.number,
                                amount: _editedMonth.amount,
                                amountLeft: _editedMonth.amountLeft,
                                year: _editedMonth.year,
                                createdAt: _editedMonth.createdAt,
                              );
                            },
                          ),
                          TextFormField(
                            decoration:
                                InputDecoration(labelText: 'Month Number'),
                            textInputAction: TextInputAction.next,
                            initialValue: _initValues['number'],
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
                              _editedMonth = Month(
                                id: _editedMonth.id,
                                name: _editedMonth.name,
                                number: int.parse(value),
                                amount: _editedMonth.amount,
                                amountLeft: _editedMonth.amountLeft,
                                year: _editedMonth.year,
                                createdAt: _editedMonth.createdAt,
                              );
                            },
                          ),
                          TextFormField(
                            decoration: InputDecoration(labelText: 'Amount'),
                            initialValue: _initValues['amount'],
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
                              _editedMonth = Month(
                                id: _editedMonth.id,
                                name: _editedMonth.name,
                                number: _editedMonth.number,
                                amount: double.parse(value),
                                amountLeft: double.parse(value),
                                year: _editedMonth.year,
                                createdAt: _editedMonth.createdAt,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
