import './widgets/stateful_widgets/user_transaction.dart';
import 'package:flutter/material.dart';

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

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _generateMainWidgetTree();
  }

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
    structureWidget.add(chartContainer);

    // userTrasaction now has its own separate state.
    structureWidget.add(UserTransaction());

    return Column(
      children: structureWidget,
      mainAxisAlignment:
          MainAxisAlignment.center, // this is new and interesting.
    );
  }
}
