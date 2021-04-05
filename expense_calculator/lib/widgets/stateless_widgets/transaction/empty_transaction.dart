import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EmptyTransaction extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 125)  here we use layoutBuilder constranits to make our heights flexible.
    return LayoutBuilder(builder: (ctx, constraints) {
      return Column(
        children: <Widget>[
          Text(
            'No transactions added yet!',
            style: Theme.of(context).textTheme.title,
          ),
          SizedBox(
            // 125) this should be fixed as well! (not with absolute numbers)
            height: constraints.maxHeight * 0.05,
          ),
          Container(
              // 125) we`ll use 60-70% since we have chart as well!
              height: constraints.maxHeight * 0.6,
              // check 99 how the image is imported!
              child: Image.asset(
                'assets/images/waiting.png',
                // in 99 it is described how it fits the within the container.
                fit: BoxFit.cover,
              )),
        ],
      );
    });

    return Column(
      children: <Widget>[
        Text(
          'No transactions added yet!',
          style: Theme.of(context).textTheme.title,
        ),
        SizedBox(
          height: 20,
        ),
        Container(
            height: 200,
            // check 99 how the image is imported!
            child: Image.asset(
              'assets/images/waiting.png',
              // in 99 it is described how it fits the within the container.
              fit: BoxFit.cover,
            )),
      ],
    );
  }
}
