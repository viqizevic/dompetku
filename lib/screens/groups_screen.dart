import 'package:dompetku/models/transaction_data.dart';
import 'package:dompetku/models/transaction.dart';
import 'package:dompetku/widgets/group_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupsScreen extends StatelessWidget {
  final TransactionsGroupingOption transactionsGroupingOption;

  GroupsScreen(this.transactionsGroupingOption);

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionData>(
      builder: (context, transactionData, child) {
        List<String> names =
            transactionData.getGroupNames(transactionsGroupingOption);
        int nCount = names.length;
        return Padding(
          padding: const EdgeInsets.only(top: 10),
          child: ListView.builder(
            itemBuilder: (context, index) {
              double sum = transactionData.getSumOfTransactions(
                  transactionData.getTransactionsByGroupName(
                      names[index], transactionsGroupingOption));
              return GroupTile(
                name: names[index],
                sum: sum,
                transactionsGroupingOption: transactionsGroupingOption,
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
