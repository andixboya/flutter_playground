import '../../widgets/elements_generator/generator.dart';
import 'package:flutter/material.dart';

class NewTransaction extends StatefulWidget {
  final Function addTransaction;

  NewTransaction(this.addTransaction);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // don`t make them properties then, dum!
    // 92 set keyBoardType as requirement!
    final _validatedAddTransaction = () {
//92) add validation to input
      final itemTitle = _titleController.text;
      final price = double.parse(_amountController.text);
      if (itemTitle == null || price <= 0) {
        return; // this should probably throw some error or make something invisible or make some element visible but maybe later it will be done.
      }

      widget.addTransaction(itemTitle,
          price); // 95) needs to be within state, because inputs within the modal would be lost!
      Navigator.of(context)
          .pop(); // 95) here we close the modal after we are done with our output (for userFriendly UI).
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
