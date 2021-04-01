import 'package:flutter/material.dart';

import 'model/transaction.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return this._generateMainWidgetTree();
  }

  final List<Transaction> _transactions = [
    Transaction(
      id: 't1',
      title: 'New Shoes',
      amount: 69.99,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't2',
      title: 'Weekly Groceries',
      amount: 16.53,
      date: DateTime.now(),
    ),
  ];

  // this is the main widgetTree
  Scaffold _generateMainWidgetTree() {
    var appBar = this._generateAppBar();
    var body = this._generateBody();

    return Scaffold(
        appBar: appBar,
        body: body); // should probably check Scaffold`s properties?
  }

// used as top_main app bar.
  AppBar _generateAppBar() {
    final textTitleWidget =
        Text('My first app.', style: TextStyle(color: Colors.red));
    return AppBar(
        title:
            textTitleWidget); // using Appbar directly, since its props are final.
  }

  // should probably be container, but w.e.
  Column _generateBody() {
    final structureWidget = <Widget>[];

    final chartContainer = Container(
      child: Card(
        color: Colors.blue,
        child: Text('This is CHAR',
            style: TextStyle(fontSize: 25, backgroundColor: Colors.green)),
        // elevation: 4, ??
      ),
      width: double.infinity,
    );
    final listContainer = _transactions
        .map(
            (tr) => Card(child: Text(tr.title, style: TextStyle(fontSize: 25))))
        .toList();
    // i`ll add the transactions here i think?

    structureWidget.add(chartContainer);
    structureWidget.addAll(listContainer);

    return Column(
      children: structureWidget,
      mainAxisAlignment:
          MainAxisAlignment.center, // this is new and interesting.
    );
  }
}
