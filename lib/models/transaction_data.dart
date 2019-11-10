import 'dart:collection';
import 'package:dompetku/models/transaction.dart';
import 'package:flutter/foundation.dart';

class TransactionData extends ChangeNotifier {
  List<Transaction> _trans = [
    Transaction(
      payee: "J.Co",
      amount: 17.49,
      date: DateTime.now(),
      category: "Eating Out",
    ),
    Transaction(
      payee: "Timezone",
      amount: 9.25,
      date: DateTime.now(),
      category: "Entertainment",
    ),
    Transaction(
      payee: "Bakso Pak Jo",
      amount: 7.4,
      date: DateTime.now().add(Duration(days: -1)),
      category: "Eating Out",
    ),
  ];

  UnmodifiableListView<Transaction> get transactions {
    return UnmodifiableListView(_trans);
  }

  int get transactionCount {
    return _trans.length;
  }
}
