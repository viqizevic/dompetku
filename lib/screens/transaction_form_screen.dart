import 'package:dompetku/models/transaction.dart';
import 'package:dompetku/models/transaction_data.dart';
import 'package:dompetku/widgets/suggestions_list.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TransactionFormScreen extends StatefulWidget {
  static const String addId = 'add';

  final Transaction transaction;

  TransactionFormScreen({this.transaction});

  @override
  _TransactionFormScreenState createState() => _TransactionFormScreenState();
}

class _TransactionFormScreenState extends State<TransactionFormScreen> {
  final payeeController = TextEditingController();
  final amountController = TextEditingController();
  final categoryController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  bool _isAnExpense = true;
  bool _inputIsValid = true;
  bool _shouldUpdateTransaction = false;
  Set<String> _usedCategories = Set<String>();
  Set<String> _previousPayees = Set<String>();

  @override
  void initState() {
    super.initState();
    if (null != widget.transaction) {
      _shouldUpdateTransaction = true;
      _isAnExpense = widget.transaction.isAnExpense;
      payeeController.text = widget.transaction.payee;
      amountController.text =
          widget.transaction.amount.abs().toStringAsFixed(2);
      categoryController.text = widget.transaction.category;
      _selectedDate = widget.transaction.date;
    }
  }

  void _toggleType() {
    setState(() {
      _isAnExpense = !_isAnExpense;
    });
    if (_previousPayees.isNotEmpty) {
      _displayPreviousPayees(payeeController.text);
    }
    if (_usedCategories.isNotEmpty) {
      _displaySuggestedCategories(categoryController.text);
    }
  }

  void _displayPreviousPayees(String input) {
    setState(() {
      _previousPayees = Provider.of<TransactionData>(context).previousPayees(
        input: input,
        forExpense: _isAnExpense,
        payeeToBeExcluded: _shouldUpdateTransaction && 1 < input.length
            ? widget.transaction.payee
            : null,
      );
    });
  }

  void _displaySuggestedCategories(String input) {
    setState(() {
      _usedCategories =
          Provider.of<TransactionData>(context).suggestedCategories(
        input: input,
        forExpense: _isAnExpense,
        categoryToBeExcluded: _shouldUpdateTransaction && 1 < input.length
            ? widget.transaction.category
            : null,
      );
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

    if (enteredPayee.isEmpty || amountController.text.isEmpty) {
      setState(() {
        _inputIsValid = false;
      });
      return;
    }

    if (_shouldUpdateTransaction) {
      if (enteredCategory.isEmpty) {
        enteredCategory = widget.transaction.category;
      }

      Provider.of<TransactionData>(context).updateTransaction(
        transactionId: widget.transaction.id,
        newPayee: enteredPayee,
        newAmount: enteredAmount,
        newCategory: enteredCategory,
        newDate: _selectedDate,
      );
    } else {
      Provider.of<TransactionData>(context).addTransaction(
        payee: enteredPayee,
        amount: enteredAmount,
        category: enteredCategory,
        date: _selectedDate,
      );
    }

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
          _shouldUpdateTransaction
              ? 'Update Transaction (id:${widget.transaction.id})'
              : 'New Transaction',
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
                onChanged: _displayPreviousPayees,
              ),
              SuggestionsList(
                suggestions: _previousPayees,
                applySuggestionCallback: (String selectedPayee) {
                  setState(() {
                    payeeController.text = selectedPayee;
                    // Clear suggestions
                    _previousPayees.clear();
                    // Put in matching category
                    String matchingCategory =
                        Provider.of<TransactionData>(context)
                            .getMatchingCategory(
                                payee: selectedPayee, forExpense: _isAnExpense);
                    if (null != matchingCategory &&
                        matchingCategory.isNotEmpty) {
                      categoryController.text = matchingCategory;
                    } else {
                      categoryController.text = '';
                    }
                  });
                },
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
                onChanged: _displaySuggestedCategories,
              ),
              SuggestionsList(
                suggestions: _usedCategories,
                applySuggestionCallback: (String chosenCategory) {
                  setState(() {
                    categoryController.text = chosenCategory;
                    _usedCategories.clear();
                  });
                },
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
                    'Payee and Amount are required.',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                visible: !_inputIsValid,
              ),
              FlatButton(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    _shouldUpdateTransaction ? 'Update' : 'Add',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
                color: Colors.blueAccent,
                onPressed: _submitData,
              ),
              Visibility(
                child: FlatButton(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Icon(
                      FontAwesomeIcons.trash,
                      color: Colors.grey,
                      size: 32,
                    ),
                  ),
                  onPressed: () {
                    Provider.of<TransactionData>(context).deleteTransaction(
                      transaction: widget.transaction,
                    );
                    Navigator.pop(context);
                  },
                ),
                visible: _shouldUpdateTransaction,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
