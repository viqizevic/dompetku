import 'package:dompetku/models/transaction_data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AddTransactionScreen extends StatefulWidget {
  static const String id = 'add';

  @override
  _AddTransactionScreenState createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final payeeController = TextEditingController();
  final amountController = TextEditingController();
  final categoryController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  bool _isAnExpense = true;
  bool _inputIsInvalid = false;

  void _toggleType() {
    setState(() {
      _isAnExpense = !_isAnExpense;
    });
  }

  void _submitData() {
    String enteredPayee = payeeController.text;
    double enteredAmount = 0;
    if (amountController.text.isNotEmpty) {
      enteredAmount = double.parse(amountController.text).abs();
      enteredAmount = double.parse(enteredAmount.toStringAsFixed(2));
      if (_isAnExpense) {
        enteredAmount = -1 * enteredAmount;
      }
    }
    String enteredCategory = categoryController.text;
    if (enteredCategory.isEmpty) {
      enteredCategory = "Uncategorized";
    }

    if (enteredPayee.isEmpty || amountController.text.isEmpty) {
      setState(() {
        _inputIsInvalid = true;
      });
      return;
    }

    Provider.of<TransactionData>(context).addTransaction(
      payee: enteredPayee,
      amount: enteredAmount,
      category: enteredCategory,
      date: _selectedDate,
    );

    Navigator.pop(context);
  }

  void _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (null == pickedDate) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context);
              }),
        ],
        title: Text(
          'New Transaction',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  FlatButton(
                    child: Text(
                      'Expense',
                      style: TextStyle(
                        color: _isAnExpense ? Colors.redAccent : Colors.grey,
                        fontStyle: FontStyle.italic,
                        fontSize: 20,
                      ),
                    ),
                    onPressed: _toggleType,
                  ),
                  FlatButton(
                    child: Text(
                      'Income',
                      style: TextStyle(
                        color: !_isAnExpense ? Colors.green : Colors.grey,
                        fontStyle: FontStyle.italic,
                        fontSize: 20,
                      ),
                    ),
                    onPressed: _toggleType,
                  ),
                ],
              ),
              TextField(
                controller: payeeController,
                autofocus: true,
                decoration: InputDecoration(labelText: 'Payee'),
                textAlign: TextAlign.center,
              ),
              TextField(
                controller: amountController,
                decoration: InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.numberWithOptions(
                  signed: false,
                  decimal: true,
                ),
                textAlign: TextAlign.center,
              ),
              TextField(
                controller: categoryController,
                decoration: InputDecoration(labelText: 'Category'),
                textAlign: TextAlign.center,
              ),
              Container(
                height: 70,
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: Text(
                      'Date: ${DateFormat.MMMEd().format(_selectedDate)}',
                      style: TextStyle(fontSize: 18),
                    )),
                    FlatButton(
                      child: Text(
                        'Choose new date',
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontStyle: FontStyle.italic,
                          fontSize: 18,
                        ),
                      ),
                      onPressed: _showDatePicker,
                    ),
                  ],
                ),
              ),
              Visibility(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    'Please enter Title and Amount.',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                visible: _inputIsInvalid,
              ),
              FlatButton(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    'Add',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
                color: Colors.blueAccent,
                onPressed: _submitData,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
