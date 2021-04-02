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
    final theme = _setTheme();

    return MaterialApp(
      title: 'Flutter App',
      home: MyHomePage(),
      theme: theme,
    );
  }

  ThemeData _setTheme() {
    return ThemeData(
        //96-7) addition of theme so that its accessible through context to every other widget.
        primarySwatch: Colors.green,
        accentColor: Colors
            .purple, // searches first for this, then for the primarySwatch.
        fontFamily:
            'Quicksand', // in order for this reference to work you need to set it in yml and have that file somwehere!
        textTheme: ThemeData.light().textTheme.copyWith(
                // previously it was title, because probably title uses  Head6 size?
                // this way we override the styles for each TITLE property!
                headline6: TextStyle(
              fontFamily: 'OpenSans',
              fontWeight: FontWeight.bold,
              fontSize: 18,
            )),
        appBarTheme: AppBarTheme(
          // theme used specifically for appBar
          textTheme: ThemeData.light().textTheme.copyWith(
                headline6: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
        ));
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
        color: Theme.of(context).accentColor,
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
        //97-8) here we replace the color with the theme`s color. otherwise it wouldn not bind.
        Text(
      'My first app.',
      // style: TextStyle(color: Theme.of(context).primaryColor)
    );
    return AppBar(
      title: textTitleWidget,
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () => _modalShowAddNewTransaction(
              context), // 94. addition of modalShow.
          color: Theme.of(context).accentColor,
          highlightColor: Colors.green,
        )
      ],
    ); // using Appbar directly, since its props are final.
  }

  Widget _generateBody() {
    final structureWidget = <Widget>[];

    final chartContainer = Container(
      child: Card(
        color: Colors.blue,
        child: Text('This is CHAR',
            style: TextStyle(fontSize: 12, backgroundColor: Colors.green)),
        elevation: 4, // what is this thing
      ),
      width: double.infinity,
    );
    structureWidget.add(chartContainer);

    // userTrasaction now has its own separate state.
    structureWidget.add(Column(
      // this was another stateful widget, but w.e.
      children: <Widget>[
        TransactionList(_userTransactions),
      ],
    ));

    // added this wrapper, because it caused some stupid margin creation. column apparently has half display height as default or sth?
    // this was added during scrolling, but i`ve forgotten?
    // need to check what this was about again? 90 !!!
    return SingleChildScrollView(
      child: Column(
        children: structureWidget,
        mainAxisAlignment:
            MainAxisAlignment.center, // this is new and interesting.
      ),
    );
  }
}
