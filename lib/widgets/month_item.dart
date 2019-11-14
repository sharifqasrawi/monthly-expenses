import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/month.dart';
import '../providers/months.dart';
import '../screens/month_update_screen.dart';
import '../screens/payments.screen.dart';

class MonthItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final month = Provider.of<Month>(context, listen: false);

    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          PaymentsScreen.routeName,
          arguments: month.id,
        );
      },
      child: Dismissible(
        key: ValueKey(month.id),
        background: Container(
          color: Colors.greenAccent,
          child: Icon(
            Icons.edit,
            color: Colors.white,
            size: 40,
          ),
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
        ),
        secondaryBackground: Container(
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
        onDismissed: (direction) {
          if (direction == DismissDirection.endToStart) {
            Provider.of<Months>(context, listen: false).deleteMonth(month.id);
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text('${month.name} deleted.'),
              duration: Duration(seconds: 2),
            ));
          } else if (direction == DismissDirection.startToEnd) {
            Navigator.of(context).pushNamed(MonthUpdateScreen.routeName, arguments: month.id);
          }
        },
        confirmDismiss: (direction) {
          if (direction == DismissDirection.endToStart) {
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
          } else {
            return showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('Update Month'),
                content: const Text('Navigate to update page?'),
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
          }
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
                  padding: const EdgeInsets.all(1),
                  child: FittedBox(
                    child: Text(
                      month.number.toString(),
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ),
            ),
            title: Text(month.name),
            subtitle: Row(
              children: <Widget>[
                Text(
                  '${month.amountLeft.toStringAsFixed(2)}€',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.red),
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  '${month.amount.toStringAsFixed(2)}€',
                  style: const TextStyle(color: Colors.green),
                ),
              ],
            ),
            trailing: Text(month.year.toString()),
          ),
        ),
      ),
    );
  }
}
