import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionTile extends StatelessWidget {
  final String payee;
  final double amount;
  final DateTime date;
  final String category;
  final bool isAnExpense;
  final Function onTapCallback;
  final bool isLastTile;

  TransactionTile({
    this.payee,
    this.amount,
    this.date,
    this.category,
    this.isAnExpense,
    this.onTapCallback,
    this.isLastTile,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          onTap: onTapCallback,
          title: Row(
            children: <Widget>[
              Column(
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColor,
                    radius: 24,
                    child: Padding(
                      padding: const EdgeInsets.all(7.0),
                      child: FittedBox(
                        child: Text(
                          payee.substring(0, 1),
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  )
                ],
              ),
              SizedBox(
                width: 15,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  FittedBox(
                    child: Text(
                      payee,
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Text(
                    category,
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
                  )
                ],
              ),
            ],
          ),
          leading: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                DateFormat.d().format(date),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(DateFormat.MMM().format(date)),
            ],
          ),
          trailing: Text(
            '€${amount.abs().toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: isAnExpense ? Colors.red.shade800 : Colors.green,
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
