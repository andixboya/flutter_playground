import 'package:intl/intl.dart';

import '../../elements_generator/generator.dart';
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

  DateTime _selectedDate;
  void _presentDatePicker() {
    // 110-113 [imp/] this is probably the most interesting part, as it shows a datePicker widget (real one )
    // and you don`t need to include it anywhere. Its like a modal and it returns a value, which you use directly.
    // built in too!
    showDatePicker(
      context: context,
      // you can assign a default date
      initialDate: DateTime.now(),

      // min date!
      firstDate: DateTime(2020),

      // max date!
      lastDate: DateTime.now(),
      // it returns a Future<> or promise or observable, you name it.
    ).then((pickedDate) {
      // here you just need to validate the date and set it on your state!
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
    print('...');
  }

  @override
  Widget build(BuildContext context) {
    // from 110-113 we need to add date field in the create new transaction as well!

// don`t make them properties then, dum!
    // 92 set keyBoardType as requirement!
    final _validatedAddTransaction = () {
      if (_amountController.text.isEmpty) {
        return;
      }
      //92) add validation to input
      final itemTitle = _titleController.text;
      final price = double.parse(_amountController.text);

      // from 110-113 we add check for date in case its invalid
      if (itemTitle == null || price <= 0 || _selectedDate == null) {
        return; // this should probably throw some error or make something invisible or make some element visible but maybe later it will be done.
      }

      // 95) needs to be within state, because inputs within the modal would be lost!
      widget.addTransaction(itemTitle, price, _selectedDate);

      // 95) here we close the modal after we are done with our output (for userFriendly UI).
      Navigator.of(context).pop();
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
            // 110-113 here you just set a widget which displays date, while the datePicker is a function built in
            // which you can access and it gives you some date!
            // below you set a simple output field and date which will visualize your ouput.
            //  you don`t create a widget for yourself for the date! Its built in!
            Container(
              height: 70,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      _selectedDate == null
                          ? 'No Date Chosen!'
                          : 'Picked Date: ${DateFormat.yMd().format(_selectedDate)}',
                    ),
                  ),
                  FlatButton(
                    textColor: Theme.of(context).primaryColor,
                    child: Text(
                      'Choose Date',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: _presentDatePicker,
                  ),
                ],
              ),
            ),
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
