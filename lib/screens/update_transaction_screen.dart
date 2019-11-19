import 'package:dompetku/models/transaction.dart';
import 'package:dompetku/models/transaction_data.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class UpdateTransactionScreen extends StatefulWidget {
  final Transaction transaction;

  UpdateTransactionScreen({this.transaction});

  @override
  _UpdateTransactionScreenState createState() =>
      _UpdateTransactionScreenState();
}

class _UpdateTransactionScreenState extends State<UpdateTransactionScreen> {
  final payeeController = TextEditingController();
  final amountController = TextEditingController();
  final categoryController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  bool _isAnExpense = true;
  bool _inputIsInvalid = false;

  @override
  void initState() {
    super.initState();
    _isAnExpense = widget.transaction.isAnExpense;
    payeeController.text = widget.transaction.payee;
    amountController.text = widget.transaction.amount.abs().toStringAsFixed(2);
    categoryController.text = widget.transaction.category;
    _selectedDate = widget.transaction.date;
  }

  void _toggleType() {
    setState(() {
      _isAnExpense = !_isAnExpense;
    });
  }

  void _updateData() {
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
      enteredCategory = widget.transaction.category;
    }

    if (enteredPayee.isEmpty || amountController.text.isEmpty) {
      setState(() {
        _inputIsInvalid = true;
      });
      return;
    }

    Provider.of<TransactionData>(context).updateTransaction(
      transactionId: widget.transaction.id,
      newPayee: enteredPayee,
      newAmount: enteredAmount,
      newCategory: enteredCategory,
      newDate: _selectedDate,
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
          'Update Transaction (id:${widget.transaction.id})',
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
                  signed: true,
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
                    'Update',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                color: Colors.blueAccent,
                onPressed: _updateData,
              ),
              FlatButton(
                child: Icon(
                  FontAwesomeIcons.trash,
                  color: Colors.grey,
                ),
                onPressed: () {
                  Provider.of<TransactionData>(context).deleteTransaction(
                    transaction: widget.transaction,
                  );
                  Navigator.pop(context);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
