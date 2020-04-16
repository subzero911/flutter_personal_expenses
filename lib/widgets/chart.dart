import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:personal_expenses/model/transaction.dart';
import 'package:personal_expenses/widgets/chart_bar.dart';

// самописная диаграмма

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  Chart(this.recentTransactions);

  // список пар день-стоимость
  List<Map<String, Object>> get groupedTransactionsValues {
    return List.generate(7, (index) {
      // в каждой итерации вычитаем 1 день из текущей даты
      final weekDay = DateTime.now().subtract(Duration(days: index));
      double totalSum = 0.0; // общие расходы за день

      for (var i = 0; i < recentTransactions.length; i++) {
        // если в recentTransactions запись имеет такую же дату
        if (recentTransactions[i].date.day == weekDay.day &&
            recentTransactions[i].date.month == weekDay.month &&
            recentTransactions[i].date.year == weekDay.year) {
          // добавляем потраченные деньги к общей сумме
          totalSum += recentTransactions[i].amount;
        }
      }

      return {
        // E форматирует день как Mon, Tue, Wed...
        // с помощью substring извлекаем первую букву
        'day': DateFormat.E().format(weekDay),//.substring(0, 1),
        'amount': totalSum, // потрачено за день
      };
    }).reversed.toList();
  }

  double get totalSpending {
    return groupedTransactionsValues.fold(0.0, (sum, item) {
      return sum + item['amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransactionsValues.map((data) {
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                  data['day'],
                  data['amount'],
                  totalSpending == 0.0
                      ? 0.0
                      : (data['amount'] as double) / totalSpending),
            );
          }).toList(),
        ),
      ),
    );
  }
}
