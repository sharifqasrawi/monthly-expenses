import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/payment.dart';
//import '../providers/payments.dart';
import './payment_item.dart';

class PaymentsList extends StatefulWidget {
  final List<Payment> payments;
  final double amount;
  final double amountLeft;
  final currency;

  PaymentsList({
    this.payments,
    this.amount,
    this.amountLeft,
    this.currency,
  });

  @override
  _PaymentsListState createState() => _PaymentsListState();
}

class _PaymentsListState extends State<PaymentsList> {
  //var _isLoading = false;
  var _isInit = true;

  // Future<void> _fetchData() async {
  //   await Provider.of<Payments>(context).fetchAndSetPayments();
  // }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        //_isLoading = true;
      });
      // _fetchData();
      setState(() {
        //_isLoading = false;
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black38,
      child: widget.payments.length > 0
          ? ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: widget.payments.length,
              itemBuilder: (ctx, idx) => ChangeNotifierProvider.value(
                value: widget.payments[idx],
                child: PaymentItem(currency: widget.currency,),
              ),
            )
          : Center(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.white60,
                ),
                padding: const EdgeInsets.all(10),
                child: Text(
                  'NO PAYMENTS YET',
                  style: TextStyle(color: Theme.of(context).errorColor),
                ),
              ),
            ),
    );
  }
}
