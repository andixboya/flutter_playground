import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  final String label;
  final double spendingAmount;
  final double spendingPctOfTotal;

  ChartBar(this.label, this.spendingAmount, this.spendingPctOfTotal);

  @override
  Widget build(BuildContext context) {
// 122) usecase of layoutBuilder which is necessary for proper resizing
// It takes the size of the current container as max height/width.
    return LayoutBuilder(builder: (context, constraints) {
      // 122) now , witihn the builder you can use the size/constraints of the current widget!
      // We should calculate them so that we occupy the full space.
      // We could also leave some but it should be intentional!
      return Column(
        children: <Widget>[
          // (103-105~) used for fitting text and making it smaller, in case its too long.
          // 122 here we get the measurements not from the device , but for the widget`s constraints!
          Container(
            height: constraints.maxHeight * 0.15,
            child: FittedBox(
              child: Text('\$${spendingAmount.toStringAsFixed(0)}'),
            ),
          ),
          // 122 here we get the measurements not from the device , but for the widget`s constraints!
          SizedBox(
            height: constraints.maxHeight * 0.05,
          ),
          // 122 here we get the measurements not from the device , but for the widget`s constraints!
          Container(
            height: constraints.maxHeight * 0.6,
            width: 10,
            child: Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1.0),
                    color: Color.fromRGBO(220, 220, 220, 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                // (103-105~) Takes a FRACTION (0.00-1.00) of the PARENT ELEMENT SIZE(heigh/width)
                FractionallySizedBox(
                  heightFactor: spendingPctOfTotal,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // 122 here we get the measurements not from the device , but for the widget`s constraints!
          SizedBox(
            height: constraints.maxHeight * 0.05,
          ),
          // 122 here we get the measurements not from the device , but for the widget`s constraints!
          Container(
            height: constraints.maxHeight * 0.15,
            child: FittedBox(
              child: Text(label),
            ),
          ),
        ],
      );
    });
  }
}
