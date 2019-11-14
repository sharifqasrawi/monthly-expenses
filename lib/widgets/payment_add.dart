import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/months.dart';
import '../providers/payment.dart';
import '../providers/payments.dart';

class AddPayment extends StatefulWidget {
  final monthId;
  AddPayment(this.monthId);
  @override
  _AddPaymentState createState() => _AddPaymentState();
}

class _AddPaymentState extends State<AddPayment> {
  //var _isLoading = false;
  final _form = GlobalKey<FormState>();
  final _titleFocusNode = FocusNode();
  

  var _payment = Payment(
    id: null,
    amount: 0.0,
    title: '',
    createdAt: DateTime.now(),
    monthId: '',
  );


  @override
  void dispose() {
    _titleFocusNode.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();

    try {
      _payment = Payment(
        id: _payment.id,
        amount: _payment.amount,
        title: _payment.title,
        monthId: widget.monthId,
        createdAt: DateTime.now(),
      );

      Provider.of<Payments>(context, listen: false).addPayment(_payment);
      Provider.of<Months>(context, listen: false)
          .updateAmountLeft(monthId: _payment.monthId, amount: _payment.amount);

      setState(() {
        //_isLoading = true;
      });
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
        //_isLoading = false;
      });
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(211, 214, 227, 0.9),
      padding: EdgeInsets.fromLTRB(
        10,
        10,
        10,
        MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Form(
        key: _form,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Amount'),
                autofocus: true,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Amount is required';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid amount';
                  }
                  if (double.parse(value) <= 0.0) {
                    return 'Amount must be greater than 0';
                  }
                  return null;
                },
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_titleFocusNode);
                },
                onSaved: (value) {
                  _payment = Payment(
                    id: _payment.id,
                    title: _payment.title,
                    monthId: _payment.monthId,
                    createdAt: _payment.createdAt,
                    amount: double.parse(value),
                  );
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Title'),
                focusNode: _titleFocusNode,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Title is required';
                  }
                  return null;
                },
                onSaved: (value) {
                  _payment = Payment(
                    id: _payment.id,
                    title: value,
                    monthId: _payment.monthId,
                    createdAt: _payment.createdAt,
                    amount: _payment.amount,
                  );
                },
              ),
              FlatButton(
                child: Text('Add'),
                textColor: Colors.blue,
                onPressed: _saveForm,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
