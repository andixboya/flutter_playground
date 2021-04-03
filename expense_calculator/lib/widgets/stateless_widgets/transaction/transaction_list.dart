import 'package:expense_calculator/model/transaction.dart';
import 'package:expense_calculator/widgets/stateless_widgets/transaction/empty_transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> _transactions;

  TransactionList(this._transactions);

  @override
  Widget build(BuildContext context) {
    return _transactions.isEmpty
        ? EmptyTransaction()
        : Container(
            height: 200,
            child: ListView.builder(
                itemBuilder: (context, i) {
                  return Card(
                    child: Row(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 15,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.purple,
                              width: 2,
                            ),
                          ),
                          padding: EdgeInsets.all(10),
                          child: Text(
                            '\$${_transactions[i].amount.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Theme.of(context)
                                  .primaryColor, // 96-7) here we set the primary context color.
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              _transactions[i].title,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6, // 96-7) here we set the font+ style from theme.
                            ),
                            Text(
                              DateFormat.yMMMd().format(_transactions[i].date),
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
                itemCount: this._transactions.length));
  }
}
