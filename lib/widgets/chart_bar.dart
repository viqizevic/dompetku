import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  final double barHeight = 100;
  final double barWidth = 8;

  final String label;
  final double expensePercentage;
  final double incomePercentage;

  ChartBar({
    this.label,
    this.expensePercentage,
    this.incomePercentage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
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
              width: barWidth,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: <Widget>[
                  FractionallySizedBox(
                    heightFactor: incomePercentage,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.green,
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
              width: barWidth,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: <Widget>[
                  FractionallySizedBox(
                    heightFactor: expensePercentage,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.red.shade800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
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
