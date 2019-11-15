import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/months.dart';
import './month_item.dart';

class MonthsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final monthsContainer = Provider.of<Months>(context);
    final months = monthsContainer.items;

    return Container(
      color: Colors.black38,
      child: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: months.length,
        itemBuilder: (ctx, idx) => ChangeNotifierProvider.value(
          value: months[idx],
          child: MonthItem(),
        ),
      ),
    );
  }
}
