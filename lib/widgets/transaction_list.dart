import 'package:flutter/material.dart';
import '../model/transaction.dart';
import './transaction_item.dart';

/// создает из списка транзакций ListView с виджетами
class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTx;

  TransactionList(this.transactions, this.deleteTx);

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        // если нет транзакций, рисуем текст "Нет тразнакций" и картинку "сон"
        ? LayoutBuilder(
            builder: (ctx, constraints) {
              return Column(
                children: <Widget>[
                  Text(
                    "No transactions added yet!",
                    style: Theme.of(context).textTheme.title,
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: constraints.maxHeight * .6,
                    child: Image.asset(
                      'assets/images/waiting.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              );
            },
          )
        // если есть транзакции:
        : ListView.builder(
            itemBuilder: (ctx, index) {
              // конвертируем каждый элемент списка в карточку
              return TransactionItem(
                //key: ValueKey(transactions[index].id),  // не нужен для Stateless Item                
                transaction: transactions[index],
                deleteTx: deleteTx,
              );
            }, //itemBuilder
            itemCount: transactions.length,
          );
  }
}
