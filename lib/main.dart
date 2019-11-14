import 'package:dompetku/models/transaction_data.dart';
import 'package:dompetku/screens/add_transaction_screen.dart';
import 'package:dompetku/screens/transactions_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (context) => TransactionData(),
      child: MaterialApp(
        initialRoute: TransactionsScreen.id,
        routes: {
          TransactionsScreen.id: (context) => TransactionsScreen(),
          AddTransactionScreen.id: (context) => AddTransactionScreen(),
        },
      ),
    );
  }
}
