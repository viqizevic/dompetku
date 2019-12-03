import 'package:dompetku/models/transaction_data.dart';
import 'package:dompetku/models/transaction.dart';
import 'package:dompetku/widgets/transactions_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupedTransactionsScreen extends StatefulWidget {
  static const String id = 'grouped-transactions';

  @override
  _GroupedTransactionsScreenState createState() =>
      _GroupedTransactionsScreenState();
}

class _GroupedTransactionsScreenState extends State<GroupedTransactionsScreen> {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args = ModalRoute.of(context).settings.arguments;
    final String name = args['name'];
    final TransactionsGroupingOption option = args['grouping'];
    final TransactionsFilterOption filter = args['filter'];

    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: Consumer<TransactionData>(
        builder: (ctx, transactionData, child) =>
            TransactionsList(transactionData.getTransactionsByGroupName(
          name,
          option,
          transactionsFilterOption: filter,
        )),
      ),
    );
  }
}
