import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/months.dart';
import '../providers/payments.dart';
import '../widgets/payment_add.dart';
import '../widgets/payments_list.dart';

class PaymentsScreen extends StatefulWidget {
  static const routeName = '/payments';

  @override
  _PaymentsScreenState createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends State<PaymentsScreen> {
  var _isLoading = false;
  var _isInit = true;

  Future<void> _fetchData() async {
    await Provider.of<Payments>(context).fetchAndSetPayments();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      _fetchData().then((_) {
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
    final mediaQuery = MediaQuery.of(context);
    final monthId = ModalRoute.of(context).settings.arguments as String;
    final month = Provider.of<Months>(context).findById(monthId);
    final amount = month.amount;
    final amountLeft = month.amountLeft;

    final payments =
        Provider.of<Payments>(context).getPaymentsByMonthId(monthId);

    void _startAddPayment() {
      showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (_) => AddPayment(monthId));
    }

    var appBar = AppBar(
      title: Row(children: [
        Text('${month.name}'),
      ]),
      actions: <Widget>[
        FlatButton(
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: _startAddPayment,
        ),
      ],
    );

    return Scaffold(
      appBar: appBar,
      body: Container(
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
        child: RefreshIndicator(
          onRefresh: _fetchData,
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    height: (mediaQuery.size.height -
                            appBar.preferredSize.height -
                            mediaQuery.padding.top) *
                        0.15,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 4,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: Card(
                        elevation: 10,
                        color: Color.fromRGBO(158, 170, 219, 1),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Text(
                                '${amountLeft.toStringAsFixed(2)}€',
                                style: const TextStyle(
                                  fontSize: 28,
                                  color: Colors.red,
                                ),
                              ),
                              Text(
                                '${amount.toStringAsFixed(2)} €',
                                style: const TextStyle(
                                  fontSize: 28,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: (mediaQuery.size.height -
                            appBar.preferredSize.height -
                            mediaQuery.padding.top) *
                        0.85,
                    child: _isLoading
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : PaymentsList(
                            payments: payments,
                            amount: amount,
                            amountLeft: amountLeft,
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: _startAddPayment,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
