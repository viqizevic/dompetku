import 'package:dompetku/models/transactions_grouping_option.dart';
import 'package:dompetku/screens/grouped_transactions_screen.dart';
import 'package:flutter/material.dart';

class GroupTile extends StatelessWidget {
  final String name;
  final double sum;
  final TransactionsGroupingOption transactionsGroupingOption;
  final bool isLastTile;

  GroupTile({
    this.name,
    this.sum,
    this.transactionsGroupingOption,
    this.isLastTile,
  });

  void selectCategory(BuildContext context) {
    Navigator.of(context).pushNamed(
      GroupedTransactionsScreen.id,
      arguments: {
        'name': name,
        'grouping': transactionsGroupingOption,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: ListTile(
            onTap: () => selectCategory(context),
            title: Text(
              name,
              style: TextStyle(
                color: Colors.blueAccent,
                fontSize: 25,
                fontWeight: FontWeight.w700,
              ),
            ),
            trailing: Text(
              '€${sum.abs().toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: sum < 0 ? Colors.red.shade800 : Colors.green,
              ),
            ),
          ),
        ),
        Visibility(
          child: Divider(),
          visible: !isLastTile,
        ),
      ],
    );
  }
}
