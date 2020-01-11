import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:dompetku/models/transaction_data.dart';

class TransactionTile extends StatelessWidget {
  final int id;
  final String payee;
  final double amount;
  final DateTime date;
  final String category;
  final bool isAnExpense;
  final Function onTapCallback;
  final bool isLastTile;

  TransactionTile({
    @required this.id,
    @required this.payee,
    @required this.amount,
    @required this.date,
    @required this.category,
    @required this.isAnExpense,
    @required this.onTapCallback,
    this.isLastTile,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Dismissible(
          key: ValueKey(id),
          background: Container(
            color: Theme.of(context).errorColor,
            child: Icon(
              Icons.delete,
              color: Colors.white,
              size: 40,
            ),
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(right: 20),
            margin: EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 4,
            ),
          ),
          direction: DismissDirection.endToStart,
          confirmDismiss: (direction) {
            return showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: Text('Are you sure?'),
                content: Text('Do you want to remove this transaction?'),
                actions: <Widget>[
                  FlatButton(
                    child: Text('No'),
                    onPressed: () {
                      Navigator.of(ctx).pop(false);
                    },
                  ),
                  FlatButton(
                    child: Text('Yes'),
                    onPressed: () {
                      Navigator.of(ctx).pop(true);
                    },
                  ),
                ],
              ),
            );
          },
          onDismissed: (direction) {
            Provider.of<TransactionData>(context, listen: false)
                .deleteTransactionById(id);
          },
          child: ListTile(
            onTap: onTapCallback,
            title: Row(
              children: <Widget>[
                Container(
                  width: 40.0,
                  child: Column(
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
                ),
                SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: Column(
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
        ),
        Visibility(
          child: Divider(),
          visible: !isLastTile,
        ),
      ],
    );
  }
}
