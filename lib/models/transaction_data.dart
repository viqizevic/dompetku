import 'dart:collection';
import 'package:dompetku/models/database_helper.dart';
import 'package:dompetku/models/transaction.dart';
import 'package:flutter/foundation.dart';

class TransactionData extends ChangeNotifier {
  List<Transaction> _trans = [];
  int newIdCounter = 1;

  TransactionData() {
    readData();
  }

  void readData() async {
    DatabaseHelper helper = DatabaseHelper.instance;
    int rowId = 1;
    Transaction tx = await helper.queryTransaction(rowId);
    if (null == tx) {
      addTransaction(
          payee: "Bank A", amount: 50, category: "Cash", date: DateTime.now());
      addTransaction(
          payee: "Resto B",
          amount: -10,
          category: "Eating Out",
          date: DateTime.now());
    } else {
      _trans.add(tx);
    }
  }

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
  }) async {
    Transaction tx = Transaction(
      id: newIdCounter,
      payee: payee,
      amount: amount,
      category: category,
      date: date,
    );
    newIdCounter++;
    _trans.add(tx);
    DatabaseHelper helper = DatabaseHelper.instance;
    await helper.insert(tx);
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
