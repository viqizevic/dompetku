import 'package:dompetku/screens/category_transactions_screen.dart';
import 'package:flutter/material.dart';

class CategoryTile extends StatelessWidget {
  final String name;
  final double sum;
  final bool isLastTile;

  CategoryTile({this.name, this.sum, this.isLastTile});

  void selectCategory(BuildContext context) {
    Navigator.of(context).pushNamed(
      CategoryTransactionsScreen.id,
      arguments: name,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: ListTile(
            onTap: () => selectCategory(context),
            title: Text(
              name,
              style: TextStyle(
                color: Colors.blueAccent,
                fontSize: 25,
                fontWeight: FontWeight.w700,
              ),
            ),
            trailing: Text(
              '€${sum.abs().toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: sum < 0 ? Colors.red.shade800 : Colors.green,
              ),
            ),
          ),
        ),
        Visibility(
          child: Divider(),
          visible: !isLastTile,
        ),
      ],
    );
  }
}
