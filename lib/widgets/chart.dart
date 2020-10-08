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
      double totalIncome = 0.0;
      double totalExpense = recentTransactions.where((tx) {
        return DateFormat.MMMEd().format(tx.date) == formattedWeekDay;
      }).fold(0, (p, tx) {
        if (!tx.isAnExpense) {
          totalIncome += tx.amount;
        }
        return p + (tx.isAnExpense ? tx.amount.abs() : 0.0);
      });
      return {
        'day': DateFormat.E().format(weekDay).substring(0, 1),
        'expense': totalExpense,
        'income': totalIncome,
      };
    }).reversed.toList();
  }

  double get maxExpenseOrIncome {
    return groupedTransactionValues.fold(0, (sum, item) {
      return max(sum, max(item['expense'], item['income']));
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
            expensePercentage: 0.0 == maxExpenseOrIncome
                ? 0.0
                : data['expense'] / maxExpenseOrIncome,
            incomePercentage: 0.0 == maxExpenseOrIncome
                ? 0.0
                : data['income'] / maxExpenseOrIncome,
          ),
        );
      }).toList(),
    );
  }
}
