import '../../widgets/elements_generator/generator.dart';
import 'package:flutter/material.dart';

class NewTransaction extends StatelessWidget {
  final Function addTx;
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();

  NewTransaction(this.addTx);

  @override
  Widget build(BuildContext context) {
    // don`t make them properties then, dummy!
    final titleInputFiled =
        ElementGenerator.generateInputField('Title', this._titleController);
    final amountIntputField =
        ElementGenerator.generateInputField('Amount', this._amountController);

    return Card(
      elevation: 5,
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            titleInputFiled,
            amountIntputField,
            // okay this is probably going to stay this way.
            FlatButton(
              child: Text('Add Transaction'),
              textColor: Colors.purple,
              onPressed: () {
                addTx(
                  _titleController.text,
                  double.parse(_amountController.text),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
