import '../../widgets/elements_generator/generator.dart';
import 'package:flutter/material.dart';

class NewTransaction extends StatelessWidget {
  final Function addTransaction;
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();

  NewTransaction(this.addTransaction);

  @override
  Widget build(BuildContext context) {
    // don`t make them properties then, dummy!
    // 92 set keyBoardType as requirement!
    //
    final _validatedAddTransaction = () {
//92) add validation to input
      final itemTitle = _titleController.text;
      final price = double.parse(_amountController.text);
      if (itemTitle == null || price <= 0) {
        return; // this should probably throw some error or make something invisible or make some element visible but maybe later it will be done.
      }

      addTransaction(itemTitle, price);
    };

    final _titleInputFiled = ElementGenerator.generateInputField(
        'Title', this._titleController, TextInputType.text,
        onEditCompleted: _validatedAddTransaction);
    final _amountIntputField = ElementGenerator.generateInputField(
        'Amount', this._amountController, TextInputType.number,
        onEditCompleted: _validatedAddTransaction);

    return Card(
      elevation: 5,
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            _titleInputFiled,
            _amountIntputField,
            // okay this is probably going to stay this way.
            FlatButton(
                child: Text('Add Transaction'),
                textColor: Colors.purple,
                //92) replacewith anonymous func
                onPressed: () => _validatedAddTransaction()),
          ],
        ),
      ),
    );
  }
}
