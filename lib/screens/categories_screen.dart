import 'package:dompetku/models/transaction_data.dart';
import 'package:dompetku/widgets/category_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoriesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionData>(
      builder: (context, transactionData, child) {
        List<String> cats = transactionData.categories;
        int nCount = cats.length;
        return Padding(
          padding: const EdgeInsets.only(top: 10),
          child: ListView.builder(
            itemBuilder: (context, index) {
              double sum = transactionData.getSumOfTransactions(
                  transactionData.getTransactionsByCategory(cats[index]));
              return CategoryTile(
                name: cats[index],
                sum: sum,
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
