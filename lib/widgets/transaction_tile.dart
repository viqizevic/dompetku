import 'package:flutter/material.dart';

class TransactionTile extends StatelessWidget {
  const TransactionTile({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: ListTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'J.Co',
              style: TextStyle(
                color: Colors.blueAccent,
                fontSize: 25,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              'Eating Out',
              style: TextStyle(
                color: Colors.blueAccent,
                fontSize: 14,
                fontStyle: FontStyle.italic,
              ),
            )
          ],
        ),
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '12',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text('Nov'),
          ],
        ),
        trailing: Text(
          '\$17,49',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}
