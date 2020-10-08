import 'package:dompetku/models/transaction_data.dart';
import 'package:dompetku/screens/grouped_transactions_screen.dart';
import 'package:dompetku/screens/tabs_screen.dart';
import 'package:dompetku/screens/transaction_form_screen.dart';
import 'package:dompetku/screens/transactions_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (context) => TransactionData(),
      child: MaterialApp(
        theme: ThemeData(
          primaryColor: Colors.blueAccent,
          accentColor: Colors.deepPurpleAccent,
          canvasColor: Colors.white,
          fontFamily: 'Raleway',
        ),
        initialRoute: TabsScreen.id,
        routes: {
          TabsScreen.id: (context) => TabsScreen(),
          TransactionsScreen.id: (context) => TransactionsScreen(),
          TransactionFormScreen.addId: (context) => TransactionFormScreen(),
          GroupedTransactionsScreen.id: (context) =>
              GroupedTransactionsScreen(),
        },
      ),
    );
  }
}
