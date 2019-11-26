import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  final double barHeight = 70;

  final String label;
  final double expensePercentage;

  ChartBar({
    this.label,
    this.expensePercentage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                width: 1,
                color: Colors.grey.shade400,
              ),
            ),
          ),
          height: barHeight,
          width: 10,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              FractionallySizedBox(
                heightFactor: expensePercentage,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.red.shade800,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 4,
        ),
        Text(
          label,
          style: TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}
