import 'package:dompetku/models/transaction_data.dart';
import 'package:dompetku/models/transaction.dart';
import 'package:dompetku/widgets/transactions_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupedTransactionsScreen extends StatelessWidget {
  static const String id = 'grouped-transactions';

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args = ModalRoute.of(context).settings.arguments;
    final String name = args['name'];
    final TransactionsGroupingOption option = args['grouping'];

    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: TransactionsList(Provider.of<TransactionData>(context)
          .getTransactionsByGroupName(name, option)),
    );
  }
}
