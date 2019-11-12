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
  bool _inputIsInvalid = false;

  @override
  void initState() {
    super.initState();
    payeeController.text = widget.transaction.payee;
    amountController.text = widget.transaction.amount.toStringAsFixed(2);
    categoryController.text = widget.transaction.category;
    _selectedDate = widget.transaction.date;
  }

  void _updateData() {
    String enteredPayee = payeeController.text;
    double enteredAmount = 0;
    if (amountController.text.isNotEmpty) {
      enteredAmount = double.parse(amountController.text);
      enteredAmount = double.parse(enteredAmount.toStringAsFixed(2));
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
    return Container(
      color: Color(0xff757575),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Column(
          children: <Widget>[
            Text(
              'Update Transaction',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.blueAccent,
              ),
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
                          'Date: ${DateFormat.MMMEd().format(_selectedDate)}')),
                  FlatButton(
                    child: Text(
                      'Choose new date',
                      style: TextStyle(fontStyle: FontStyle.italic),
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
              child: Text(
                'Update',
                style: TextStyle(
                  color: Colors.white,
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
    );
  }
}
