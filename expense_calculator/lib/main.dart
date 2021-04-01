import 'package:expense_calculator/widgets/stateless_widgets/new_transaction.dart';
import 'package:expense_calculator/widgets/stateless_widgets/transaction_list.dart';
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
  final List<Transaction> _userTransactions = [
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
  void _addNewTransaction(String txTitle, double txAmount) {
    final newTx = Transaction(
      title: txTitle,
      amount: txAmount,
      date: DateTime.now(),
      id: DateTime.now().toString(),
    );

    setState(() {
      _userTransactions.add(newTx);
    });
  }

  @override
  Widget build(BuildContext context) {
    return _generateMainWidgetTree(context);
  }

  void _modalShowAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: NewTransaction(_addNewTransaction),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  Scaffold _generateMainWidgetTree(BuildContext context) {
    final appBar = this._generateAppBar(context);
    final body = this._generateBody();
    final floatingActionButton = IconButton(
        icon: Icon(Icons.add),
        onPressed: () =>
            _modalShowAddNewTransaction(context)); // 94. we add modalShow

    return Scaffold(
      appBar: appBar,
      body: body,
      floatingActionButton: floatingActionButton,
    ); // should probably check Scaffold`s properties?
  }

  AppBar _generateAppBar(BuildContext context) {
    final textTitleWidget =
        Text('My first app.', style: TextStyle(color: Colors.red));
    return AppBar(
      title: textTitleWidget,
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () =>
              _modalShowAddNewTransaction(context), // 94. addition of modalShow.
          color: Colors.red,
          highlightColor: Colors.green,
        )
      ],
    ); // using Appbar directly, since its props are final.
  }

  Column _generateBody() {
    final structureWidget = <Widget>[];

    final chartContainer = Container(
      child: Card(
        color: Colors.blue,
        child: Text('This is CHAR',
            style: TextStyle(fontSize: 12, backgroundColor: Colors.green)),
        // elevation: 4, ??
      ),
      width: double.infinity,
    );
    structureWidget.add(chartContainer);

    // userTrasaction now has its own separate state.
    structureWidget.add(Column(
      // this was another stateful widget, but w.e.
      children: <Widget>[
        NewTransaction(_addNewTransaction),
        TransactionList(_userTransactions),
      ],
    ));

    return Column(
      children: structureWidget,
      mainAxisAlignment:
          MainAxisAlignment.center, // this is new and interesting.
    );
  }
}
