import 'package:dompetku/models/transaction_data.dart';
import 'package:dompetku/screens/transaction_form_screen.dart';
import 'package:dompetku/widgets/chart.dart';
import 'package:dompetku/widgets/transactions_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TransactionsScreen extends StatelessWidget {
  static const String id = 'transactions';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, TransactionFormScreen.addId);
        },
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 20, left: 40, right: 40, bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Total Balance',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                Text(
                  '€${Provider.of<TransactionData>(context).balance.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Chart(
                  recentTransactions:
                      Provider.of<TransactionData>(context).recentTransactions,
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
              ),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                  )),
              child: TransactionsList(
                  Provider.of<TransactionData>(context).transactions),
            ),
          )
        ],
      ),
    );
  }
}
