import 'dart:collection';
import 'dart:math';
import 'package:dompetku/models/database_helper.dart';
import 'package:dompetku/models/transaction.dart';
import 'package:flutter/foundation.dart';

enum TransactionsFilterOption {
  ThisMonth,
  LastMonth,
  All,
}

class TransactionData extends ChangeNotifier {
  List<Transaction> _trans = [];
  int newIdCounter = 1;
  DatabaseHelper dbHelper;
  bool isLoading = false;

  TransactionData() {
    dbHelper = DatabaseHelper.instance;
    loadData();
  }

  void loadData() async {
    List<Transaction> list;
    try {
      isLoading = true;
      list = await dbHelper.queryAllTransactions();
      // await Future.delayed(Duration(seconds: 3));
    } catch (e) {
      print(e);
    } finally {
      isLoading = false;
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
      notifyListeners();
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
    return getSumOfTransactions(_trans);
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

  void deleteTransactionById(int transactionId) async {
    _trans.removeWhere((tx) => tx.id == transactionId);
    await dbHelper.deleteTransaction(transactionId);
    notifyListeners();
  }

  double getSumOfTransactions(List<Transaction> transactions) {
    return transactions.fold(0, (p, q) => (p + q.amount));
  }

  List<Transaction> getTransactionsByFilter(
      TransactionsFilterOption transactionsFilterOption) {
    DateTime today = DateTime.now();
    switch (transactionsFilterOption) {
      case TransactionsFilterOption.ThisMonth:
        return _trans
            .where((tx) =>
                (tx.date.year == today.year && tx.date.month == today.month))
            .toList();
        break;
      case TransactionsFilterOption.LastMonth:
        DateTime lastMonth = DateTime(today.year, today.month, 0);
        return _trans
            .where((tx) => (tx.date.year == lastMonth.year &&
                tx.date.month == lastMonth.month))
            .toList();
        break;
      default:
        return transactions;
    }
  }

  List<String> getGroupNames(
    TransactionsGroupingOption transactionsGroupingOption, {
    TransactionsFilterOption transactionsFilterOption,
  }) {
    // Sort by Income or Expense
    List<Transaction> result =
        getTransactionsByFilter(transactionsFilterOption);
    var names = result
        .map((tx) {
          String prefix = tx.isAnExpense ? '2' : '1';
          return prefix + tx.getGroupName(transactionsGroupingOption);
        })
        .toSet()
        .toList();
    names.sort();
    names = names.map((name) => name.substring(1)).toSet().toList();
    return names;
  }

  List<Transaction> getTransactionsByGroupName(
    String groupName,
    TransactionsGroupingOption transactionsGroupingOption, {
    TransactionsFilterOption transactionsFilterOption,
  }) {
    List<Transaction> result =
        getTransactionsByFilter(transactionsFilterOption);
    return result.where((tx) {
      return tx.getGroupName(transactionsGroupingOption) == groupName;
    }).toList();
  }
}
