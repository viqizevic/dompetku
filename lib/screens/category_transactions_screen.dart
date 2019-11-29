import 'package:dompetku/models/transaction_data.dart';
import 'package:dompetku/widgets/transactions_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryTransactionsScreen extends StatelessWidget {
  static const String id = 'category_transactions';

  @override
  Widget build(BuildContext context) {
    final String category = ModalRoute.of(context).settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: Text(category),
      ),
      body: TransactionsList(Provider.of<TransactionData>(context)
          .getTransactionsByCategory(category)),
    );
  }
}
