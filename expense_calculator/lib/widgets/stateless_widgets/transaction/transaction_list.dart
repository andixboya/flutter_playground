import 'package:expense_calculator/model/transaction.dart';
import 'package:expense_calculator/widgets/stateless_widgets/transaction/empty_transaction.dart';
import 'package:expense_calculator/widgets/stateless_widgets/transaction/transaction_item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> _transactions;

  TransactionList(this._transactions, this._deleteTransaction);

  final Function _deleteTransaction;

  @override
  Widget build(BuildContext context) {
    return _transactions.isEmpty
        ? EmptyTransaction() // 125)  haha i`ve extracted it in a widget itself, so i won`t be making any changes!!!
        : Container(
            height: 200,
            child: ListView.builder(
                itemBuilder: (context, i) {
                  // 145) exatracting singleTransaction as widget
                  return TransactionItem(
                      transaction: _transactions[i],
                      deleteTransaction: _deleteTransaction);
                },
                itemCount: this._transactions.length));
  }
}
