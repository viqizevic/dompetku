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
    _trans.sort((a, b) => a.date.difference(b.date).inDays);
    return UnmodifiableListView(_trans.reversed);
  }

  UnmodifiableListView<Transaction> get recentTransactions {
    return UnmodifiableListView(_trans.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }));
  }

  int get transactionCount {
    return _trans.length;
  }

  double get balance {
    return _trans.fold(0, (p, q) => (p + q.amount));
  }

  Set<String> previousPayees(
      {String input, bool forExpense, String payeeToBeExcluded}) {
    return input.isNotEmpty
        ? _trans
            .where((tx) =>
                tx.payee.toLowerCase().startsWith(input.toLowerCase()) &&
                tx.payee != payeeToBeExcluded &&
                tx.isAnExpense == forExpense)
            .map((tx) => tx.payee)
            .toSet()
        : Set<String>();
  }

  Set<String> suggestedCategories(
      {String input, bool forExpense, String categoryToBeExcluded}) {
    return input.isNotEmpty
        ? _trans
            .where((tx) =>
                tx.category.toLowerCase().startsWith(input.toLowerCase()) &&
                tx.category != categoryToBeExcluded &&
                tx.isAnExpense == forExpense)
            .map((tx) => tx.category)
            .toSet()
        : Set<String>();
  }

  String getMatchingCategory({String payee, bool forExpense}) {
    Transaction matchingTransaction = _trans.firstWhere(
        (tx) => tx.payee == payee && tx.isAnExpense == forExpense,
        orElse: () => null);
    return null != matchingTransaction ? matchingTransaction.category : null;
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
