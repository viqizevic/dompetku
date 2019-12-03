import 'package:dompetku/models/transaction_data.dart';
import 'package:dompetku/models/transaction.dart';
import 'package:dompetku/widgets/group_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupsScreen extends StatelessWidget {
  final TransactionsGroupingOption transactionsGroupingOption;
  final TransactionsFilterOption transactionsFilterOption;

  GroupsScreen({
    this.transactionsGroupingOption,
    this.transactionsFilterOption,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionData>(
      builder: (context, transactionData, child) {
        List<String> names = transactionData.getGroupNames(
            transactionsGroupingOption,
            transactionsFilterOption: transactionsFilterOption);
        int nCount = names.length;
        return Padding(
          padding: const EdgeInsets.only(top: 10),
          child: ListView.builder(
            itemBuilder: (context, index) {
              double sum = transactionData.getSumOfTransactions(
                  transactionData.getTransactionsByGroupName(
                      names[index], transactionsGroupingOption,
                      transactionsFilterOption: transactionsFilterOption));
              return GroupTile(
                name: names[index],
                sum: sum,
                transactionsGroupingOption: transactionsGroupingOption,
                transactionsFilterOption: transactionsFilterOption,
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
