import 'package:dompetku/screens/category_transactions_screen.dart';
import 'package:flutter/material.dart';

class CategoryTile extends StatelessWidget {
  final String name;
  final bool isLastTile;

  CategoryTile({this.name, this.isLastTile});

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
