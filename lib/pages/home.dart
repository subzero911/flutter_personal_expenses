import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:personal_expenses/model/transaction.dart';
import 'package:personal_expenses/widgets/chart.dart';
import 'package:personal_expenses/widgets/new_transaction.dart';
import 'package:personal_expenses/widgets/transaction_list.dart';
import 'package:uuid/uuid.dart';

class HomePage extends StatefulWidget {
  final String title;

  HomePage({this.title});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final titleController = TextEditingController();
  final amountController = TextEditingController();

  final List<Transaction> _userTransactions = [];
  bool _showChart = false;

  bool get _isLandscape {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  // выбираем все транзакции не старее 7 дней
  List<Transaction> get _recentTransactions {
    return _userTransactions
        .where(
            (tx) => tx.date.isAfter(DateTime.now().subtract(Duration(days: 7))))
        .toList();
  }

  // добавить транзакцию в список
  void _addNewTransaction(String title, double amount, DateTime chosenDate) {
    final newTx = Transaction(
        title: title, amount: amount, date: chosenDate, id: Uuid().v4());

    setState(() {
      _userTransactions.add(newTx);
    });
  }

  // показать нижнее меню добавления транзакции
  void _startAddingNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        // карточка с полями ввода
        return GestureDetector(
          child: NewTransaction(_addNewTransaction),
          onTap: () {},
          behavior:
              HitTestBehavior.opaque, // тап на свободном месте закрывает меню
        );
      },
    );
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) => tx.id == id);
    });
  }

  List<Widget> _buildLandscapeContent(Widget chartWidget, Widget txListWidget) {
    final adaptiveSwitch = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "Show chart",
          style: Theme.of(context).textTheme.title,
        ),
        Switch.adaptive(
          activeColor: Theme.of(context).accentColor, //for iOS
          value: _showChart,
          onChanged: (val) {
            setState(() {
              _showChart = val;
            });
          },
        ),
      ],
    );

    return [
      adaptiveSwitch,
      _showChart ? chartWidget : txListWidget,
    ];
  }

  List<Widget> _buildPortraitContent(Widget chartWidget, Widget txListWidget) {
    return [chartWidget, txListWidget];
  }

  PreferredSizeWidget _buildCupertinoNavigationBar() {
    return CupertinoNavigationBar(
      middle: Text(widget.title),
      trailing: Row(
        mainAxisSize:
            MainAxisSize.min, // необходимо для правильного отображения навбара
        children: <Widget>[
          GestureDetector(
            // IconButton не поддерживается в Cupertino, делаем свою кнопку
            onTap: () => _startAddingNewTransaction(context),
            child: Icon(CupertinoIcons.add),
          )
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(widget.title),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () => _startAddingNewTransaction(context),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    // явно указываем тип PreferredSizeWidget, иначе Дарт думает, что это Widget
    final PreferredSizeWidget appBar = Platform.isIOS 
            ? _buildCupertinoNavigationBar()
            : _buildAppBar();
    final txListWidget = Container(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.7,
        child: TransactionList(_userTransactions, _deleteTransaction));
    final chartWidget = Container(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            (_isLandscape ? 0.65 : 0.3),
        child: Chart(_recentTransactions));

    final pageBody = SafeArea(
      child: SingleChildScrollView(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if (_isLandscape)
            ..._buildLandscapeContent(chartWidget, txListWidget),
          if (!_isLandscape)
            ..._buildPortraitContent(chartWidget, txListWidget),
        ],
      )),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: pageBody,
            navigationBar: appBar,
          )
        : Scaffold(
            appBar: appBar,
            body: pageBody,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    onPressed: () => _startAddingNewTransaction(context),
                    child: Icon(Icons.add),
                  ),
          );
  }
}
