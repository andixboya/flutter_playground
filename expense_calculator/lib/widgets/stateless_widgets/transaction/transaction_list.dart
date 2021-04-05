import 'package:expense_calculator/model/transaction.dart';
import 'package:expense_calculator/widgets/stateless_widgets/transaction/empty_transaction.dart';
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
                  return Card(
                    elevation: 5,
                    margin: EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 5,
                    ),
                    // 107) something like card but with built in layout within itself!
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        child: Padding(
                          padding: EdgeInsets.all(6),
                          child: FittedBox(
                            child: Text('\$${_transactions[i].amount}'),
                          ),
                        ),
                      ),
                      title: Text(
                        _transactions[i].title,
                        style: Theme.of(context).textTheme.title,
                      ),
                      subtitle: Text(
                        DateFormat.yMMMd().format(_transactions[i].date),
                      ),
                      // 110-113 here as trailing == at the end of the element an icon is added, which will delete the listed item.
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        color: Theme.of(context).errorColor,
                        onPressed: () =>
                            _deleteTransaction(_transactions[i].id),
                      ),
                    ),
                  );
                },
                itemCount: this._transactions.length));
  }
}
