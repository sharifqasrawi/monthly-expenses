import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/months.dart';
import '../providers/payment.dart';
import '../providers/payments.dart';

class PaymentItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final payment = Provider.of<Payment>(context, listen: false);

    return Dismissible(
      key: ValueKey(payment.id),
      background: Container(
        color: Colors.redAccent,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        Provider.of<Months>(context, listen: false).updateAmountLeft(
            monthId: payment.monthId, amount: -payment.amount);
        Provider.of<Payments>(context, listen: false).deletePayment(payment.id);

        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text('Payment deleted.'),
          duration: Duration(seconds: 2),
        ));
      },
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Are you sure?'),
            content: const Text('Do you want to remove this item?'),
            actions: <Widget>[
              FlatButton(
                child: const Text('No'),
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
              ),
              FlatButton(
                child: const Text('Yes'),
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                },
              ),
            ],
          ),
        );
      },
      child: Card(
        elevation: 5,
        color: Color.fromRGBO(223, 226, 237, 0.9),
        margin: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 5,
        ),
        child: ListTile(
          leading: Container(
            margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 0),
            child: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.purple,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: FittedBox(
                  child: Text(
                    '${payment.amount.toStringAsFixed(2)}€',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
          ),
          title: Text(payment.title),
          subtitle: Text(DateFormat().format(payment.createdAt)),
        ),
      ),
    );
  }
}
