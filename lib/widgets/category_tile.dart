import 'package:flutter/material.dart';

class CategoryTile extends StatelessWidget {
  final String name;
  final bool isLastTile;

  CategoryTile({this.name, this.isLastTile});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: ListTile(
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
