import 'package:dompetku/models/transaction_data.dart';
import 'package:dompetku/screens/update_transaction_screen.dart';
import 'package:dompetku/widgets/transaction_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TransactionsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionData>(
      builder: (context, transactionData, child) {
        return ListView.builder(
          padding: EdgeInsets.only(top: 10),
          itemBuilder: (context, index) {
            final transaction = transactionData.transactions[index];
            return TransactionTile(
              payee: transaction.payee,
              amount: transaction.amount,
              date: transaction.date,
              category: transaction.category,
              isAnExpense: transaction.isAnExpense,
              onTapCallback: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => UpdateTransactionScreen(
                    transaction: transaction,
                  ),
                );
              },
            );
          },
          itemCount: transactionData.transactionCount,
        );
      },
    );
  }
}
