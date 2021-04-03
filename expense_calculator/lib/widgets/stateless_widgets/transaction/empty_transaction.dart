import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EmptyTransaction extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
