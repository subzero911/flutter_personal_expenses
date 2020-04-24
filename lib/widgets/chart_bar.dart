import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  final String label;
  final double spendingAmount; // потрачено
  final double spendingPctOfTotal; // % of total

  const ChartBar(this.label, this.spendingAmount, this.spendingPctOfTotal);

  @override
  Widget build(BuildContext context) {
    // обернем в LayoutBuilder, чтобы получить доступ к constraints внутри
    return LayoutBuilder(
      builder: (ctx, constraints) {
        return Column(
          children: <Widget>[
            // $ потрачено
            Container(
              // обернем в фиксированый контейнер, чтобы столбец не подпрыгивал при уменьшении текста
              height: constraints.maxHeight * 0.15,
              child: FittedBox(
                  // FittedBox уменьшает содержимое, если оно не помещается
                  child: Text('\$${spendingAmount.toStringAsFixed(0)}')),
            ),
            // пробел
            SizedBox(
              height: constraints.maxHeight * 0.05,
            ),
            // контейнер для столбца
            Container(
              height: constraints.maxHeight * 0.6,
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
              height: constraints.maxHeight * 0.05,
            ),
            // день
            Container(
                height: constraints.maxHeight * 0.15,
                child: FittedBox(child: Text(label))),
          ],
        );
      },
    );
  }
}
