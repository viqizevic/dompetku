import 'dart:collection';
import 'dart:math';
import 'package:dompetku/models/database_helper.dart';
import 'package:dompetku/models/transaction.dart';
import 'package:flutter/foundation.dart';

class TransactionData extends ChangeNotifier {
  List<Transaction> _trans = [];
  int newIdCounter = 1;
  DatabaseHelper dbHelper;

  TransactionData() {
    dbHelper = DatabaseHelper.instance;
    readData();
  }

  void readData() async {
    List<Transaction> list = await dbHelper.queryAllTransactions();
    if (null == list || list.isEmpty) {
      addTransaction(
          payee: "Bank 1",
          amount: 50,
          category: "Cash",
          date: DateTime.now().subtract(Duration(days: 1)));
      addTransaction(
          payee: "Restaurant 2",
          amount: -10,
          category: "Eating Out",
          date: DateTime.now());
    } else {
      _trans.addAll(list);
      newIdCounter = list.fold(0, (p, q) => (max<int>(p, q.id))) + 1;
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
    await dbHelper.insert(tx);
    notifyListeners();
  }

  void updateTransaction({
    int transactionId,
    String newPayee,
    double newAmount,
    String newCategory,
    DateTime newDate,
  }) async {
    Transaction tx = _trans.firstWhere((tr) => (tr.id == transactionId));
    tx.payee = newPayee;
    tx.amount = newAmount;
    tx.category = newCategory;
    tx.date = newDate;
    await dbHelper.updateTransaction(
      id: transactionId,
      payee: newPayee,
      amount: newAmount,
      category: newCategory,
      date: newDate,
    );
    notifyListeners();
  }

  void deleteTransaction({Transaction transaction}) async {
    _trans.remove(transaction);
    await dbHelper.deleteTransaction(transaction.id);
    notifyListeners();
  }
}
