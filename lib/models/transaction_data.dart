import 'dart:collection';
import 'package:dompetku/models/transaction.dart';

class TransactionData {
  List<Transaction> _trans = [
    Transaction(payee: "J.Co", amount: 17.49),
    Transaction(payee: "J.Co", amount: 5.29),
    Transaction(payee: "Pak Jo", amount: 7.4),
  ];

  UnmodifiableListView<Transaction> get transactions {
    return UnmodifiableListView(_trans);
  }
}
