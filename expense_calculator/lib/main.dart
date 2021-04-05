import 'package:expense_calculator/widgets/stateless_widgets/chart/chart.dart';
import 'package:expense_calculator/widgets/stateless_widgets/transaction/new_transaction.dart';
import 'package:expense_calculator/widgets/stateless_widgets/transaction/transaction_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'model/transaction.dart';

void main() {
  // 123) lazy way to force your app. to have only some specific type of orientation.
  // Of course the better way is to create a separate design just for landscape/portrait mode.

  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations(
  //     [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);

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
              ),
              // 110) setting color for buttons within body, which is also nice!
              button: TextStyle(color: Colors.white),
            ),
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
  // 102-105 we`ll start with empty list, which will be replaced by an empty picture.
  final List<Transaction> _userTransactions = [];
  bool _showChart = false;

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _addNewTransaction(
      String txTitle, double txAmount, DateTime chosenDate) {
    final newTx = Transaction(
      title: txTitle,
      amount: txAmount,
      date: chosenDate,
      id: DateTime.now().toString(),
    );

    setState(() {
      _userTransactions.add(newTx);
    });
  }

  // 110-113 adding delete func. which will be transferred to the list so it can delete tx.
  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) => tx.id == id);
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
    final body = this._generateBody(appBar);
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

  Widget _generateBody(AppBar appBar) {
    final structureWidget = <Widget>[];
    // (103-105~) here we replace chart
    final chartContainer = Chart(_recentTransactions);

    final deviceFullHeight = MediaQuery.of(context).size.height;
    final supplementaryPaddingForDevice = MediaQuery.of(context).padding.top;

    // 120: here we take size from the device (top_most_level) and the size is partial! without padding for device
    //  and without appbar`s height!
    final leftoverSpace = deviceFullHeight -
        appBar.preferredSize.height -
        supplementaryPaddingForDevice;

    // final _chartHeight = leftoverSpace * 0.3;

    // 124) here we add a switch, which will hold state wether we should show chart or hide it.
    final displayChartSwitch = Row(
      children: <Widget>[
        Text('Show Chart'),
        Switch(
            value:
                _showChart, // what is reflected on the switch as value (binding).
            onChanged: (value) {
              setState(() {
                this._showChart = value;
              });
            })
      ],
      mainAxisAlignment: MainAxisAlignment.center,
    );

//126) here we add another conditional which will dictate if we need a switch (which should be only in landscape!).
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final transactionList = Container(
        child: TransactionList(_userTransactions, _deleteTransaction),
        height: leftoverSpace * 0.7);

    if (isLandscape) {
      structureWidget.add(displayChartSwitch);
      // 124) here we make a conditional which to add , but so much for the adding, because it both needs to be inside...
      this._showChart
          ? structureWidget
              // 124) since we are using if statement now onlyone element will be visible so we can occupy almost all of the sapce (or >0.7)
              .add(
                  Container(child: chartContainer, height: leftoverSpace * 0.7))
          :
          // // userTrasaction now has its own separate state.
          // // 120) we separate the leftover space between transactionList and Chart!
          structureWidget.add(transactionList);
    } else if (!isLandscape) {
      // here i use conditionals within the code , not within the build, which looks cleaner!
      // 126) in case of portrait we want 0.3 given to chart and rest to list.
      structureWidget
          .add(Container(child: chartContainer, height: leftoverSpace * 0.3));
      // 126)  and transaction list with its full height!
      structureWidget.add(transactionList);
    }

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
