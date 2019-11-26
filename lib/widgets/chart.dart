import 'package:dompetku/models/transaction.dart';
import 'package:dompetku/widgets/chart_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  Chart({this.recentTransactions});

  List<Map<String, dynamic>> get groupedTransactionValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: index));
      final String formattedWeekDay = DateFormat.MMMEd().format(weekDay);
      double totalSum = recentTransactions.where((tx) {
        return tx.isAnExpense &&
            DateFormat.MMMEd().format(tx.date) == formattedWeekDay;
      }).fold(0, (p, tx) => p + tx.amount.abs());
      return {
        'day': DateFormat.E().format(weekDay).substring(0, 1),
        'expense': totalSum,
      };
    }).reversed.toList();
  }

  double get maxExpense {
    return groupedTransactionValues.fold(0, (sum, item) {
      return max(sum, item['expense']);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: groupedTransactionValues.map((data) {
        return Flexible(
          child: ChartBar(
            label: data['day'],
            expensePercentage:
                0.0 == maxExpense ? 0.0 : data['expense'] / maxExpense,
          ),
        );
      }).toList(),
    );
  }
}
