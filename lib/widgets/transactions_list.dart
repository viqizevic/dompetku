import 'package:dompetku/models/transaction.dart';
import 'package:dompetku/screens/transaction_form_screen.dart';
import 'package:dompetku/widgets/transaction_tile.dart';
import 'package:flutter/material.dart';

class TransactionsList extends StatelessWidget {
  final List<Transaction> transactions;

  TransactionsList(this.transactions);

  @override
  Widget build(BuildContext context) {
    int nCount = transactions.length;
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: ListView.builder(
        padding: EdgeInsets.only(top: 10),
        itemBuilder: (context, index) {
          final transaction = transactions[index];
          return TransactionTile(
            id: transaction.id,
            payee: transaction.payee,
            amount: transaction.amount,
            date: transaction.date,
            category: transaction.category,
            isAnExpense: transaction.isAnExpense,
            onTapCallback: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) {
                  return TransactionFormScreen(
                    transaction: transaction,
                  );
                }),
              );
            },
            isLastTile: (index + 1 == nCount),
          );
        },
        itemCount: nCount,
      ),
    );
  }
}
