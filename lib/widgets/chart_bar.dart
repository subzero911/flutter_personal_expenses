import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  final String label;
  final double spendingAmount; // потрачено
  final double spendingPctOfTotal; // % of total

  ChartBar(this.label, this.spendingAmount, this.spendingPctOfTotal);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        // $ потрачено
        Container(                   // обернем в фиксированый контейнер, чтобы столбец не подпрыгивал при уменьшении текста
          height: 20,
          child: FittedBox (         // FittedBox уменьшает содержимое, если оно не помещается          
            child: Text('\$${spendingAmount.toStringAsFixed(0)}')
          ),
        ),
        // пробел
        SizedBox(
          height: 4,
        ),
        // контейнер для столбца
        Container(
          height: 60,
          width: 10,
          child: Stack(
            children: <Widget>[
              // фон столбца
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1.0),
                    color: Color.fromRGBO(220, 220, 220, 1), // light grey
                    borderRadius: BorderRadius.circular(10)),
              ),
              // заливка
              FractionallySizedBox(
                heightFactor: spendingPctOfTotal,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
        // пробел
        SizedBox(
          height: 4,
        ),
        // день
        Text(label),
      ],
    );
  }
}
