import 'package:flutter/material.dart';

class ElementGenerator {
  static TextField generateInputField(
      String label, TextEditingController controller, TextInputType type,
      {Function onEditCompleted}) {
    return TextField(
      decoration: InputDecoration(labelText: label),
      controller: controller,
      keyboardType: type,
      onEditingComplete: onEditCompleted,

      // onChanged: (val) => amountInput = val, // or you can pass func to which takes the data from the textField.
    );
  }

  // okay , maybe buttons won`t work... since i need to put exact args!
  // static FlatButton buttonGenerator (String text, Color color, Function onPressFunc){
  //   if (color==null) {
  //     color=Colors.purple;
  //   }
  //   return FlatButton(
  //             child: Text('Add Transaction'),
  //             textColor: Colors.purple,
  //             onPressed: () {
  //               addTx(
  //                 titleController.text,
  //                 double.parse(amountController.text),
  //               );
  //             },
  //           ),
  // }
}
