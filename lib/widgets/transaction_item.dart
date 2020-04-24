import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/transaction.dart';

class TransactionItem extends StatelessWidget {
  TransactionItem({
    Key key,
    @required this.transaction,
    @required this.deleteTx,    
  }) : super(key: key);

  final Transaction transaction;
  final Function deleteTx;  

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
      elevation: 5,
      child: ListTile(
        leading: Container(
          width: 90,
          height: 40,
          decoration: BoxDecoration(
            border: Border.all(
                color: Theme.of(context).primaryColor, width: 2),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          padding: const EdgeInsets.all(8),
          alignment: Alignment.center,
          child: FittedBox(
            child: Text(
              "\$${transaction.amount.toStringAsFixed(2)}",
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
          ),
        ),
        title: Text(
          transaction.title,
          style: Theme.of(context).textTheme.title,
        ),
        subtitle:
            Text(DateFormat.yMMMd().format(transaction.date)),
        trailing: MediaQuery.of(context).size.width > 460
          ? FlatButton.icon(
            onPressed: () => deleteTx(transaction.id),
            icon: const Icon(Icons.delete),                                            
            textColor: Theme.of(context).errorColor,
            label: const Text("Delete"))
          : IconButton(
            icon: const Icon(Icons.delete),
            color: Theme.of(context).errorColor,
            onPressed: () => deleteTx(transaction.id),
        ),
      ),
    );
  }
}
