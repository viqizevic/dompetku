import 'package:dompetku/models/transaction_data.dart';
import 'package:dompetku/screens/transaction_form_screen.dart';
import 'package:dompetku/widgets/transaction_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TransactionsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionData>(
      builder: (context, transactionData, child) {
        int nCount = transactionData.transactionCount;
        return Padding(
          padding: const EdgeInsets.only(top: 8),
          child: ListView.builder(
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
                  Navigator.push(
                    context,
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
      },
    );
  }
}
