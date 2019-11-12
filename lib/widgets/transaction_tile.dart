import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionTile extends StatelessWidget {
  final String payee;
  final double amount;
  final DateTime date;
  final String category;
  final bool isAnExpense;
  final Function onTapCallback;

  TransactionTile({
    this.payee,
    this.amount,
    this.date,
    this.category,
    this.isAnExpense,
    this.onTapCallback,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: Colors.grey.shade400,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          top: 12,
          bottom: 6,
        ),
        child: ListTile(
          onTap: onTapCallback,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                payee,
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                category,
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                ),
              )
            ],
          ),
          leading: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                DateFormat.d().format(date),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(DateFormat.MMM().format(date)),
            ],
          ),
          trailing: Text(
            '€${amount.abs().toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w900,
              color: isAnExpense ? Colors.red.shade800 : Colors.green,
            ),
          ),
        ),
      ),
    );
  }
}
