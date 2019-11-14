import 'dart:collection';
import 'package:dompetku/models/transaction.dart';
import 'package:flutter/foundation.dart';

class TransactionData extends ChangeNotifier {
  List<Transaction> _trans = [
    Transaction(
      id: 1,
      payee: "BCA",
      amount: 50,
      date: DateTime.now().add(Duration(days: -1)),
      category: "Cash",
    ),
    Transaction(
      id: 3,
      payee: "Ayam Penyet",
      amount: -4.24,
      date: DateTime.now().add(Duration(days: -1)),
      category: "Eating Out",
    ),
    Transaction(
      id: 4,
      payee: "Bakso Pak Jo",
      amount: -2.4,
      date: DateTime.now(),
      category: "Eating Out",
    ),
    Transaction(
      id: 2,
      payee: "Starbucks",
      amount: -3.49,
      date: DateTime.now(),
      category: "Drink Out",
    ),
  ];

  UnmodifiableListView<Transaction> get transactions {
    return UnmodifiableListView(_trans.reversed);
  }

  int get transactionCount {
    return _trans.length;
  }

  double get balance {
    return _trans.fold(0, (p, q) => (p + q.amount));
  }

  void addTransaction({
    String payee,
    double amount,
    String category,
    DateTime date,
  }) {
    _trans.add(Transaction(
      payee: payee,
      amount: amount,
      category: category,
      date: date,
    ));
    notifyListeners();
  }

  void updateTransaction({
    int transactionId,
    String newPayee,
    double newAmount,
    String newCategory,
    DateTime newDate,
  }) {
    Transaction tx = _trans.firstWhere((tr) => (tr.id == transactionId));
    tx.payee = newPayee;
    tx.amount = newAmount;
    tx.category = newCategory;
    tx.date = newDate;
    notifyListeners();
  }

  void deleteTransaction({Transaction transaction}) {
    _trans.remove(transaction);
    notifyListeners();
  }
}
