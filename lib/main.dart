import 'package:flutter/material.dart';
import './pages/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expenses',      
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.amber,   
        // основной шрифт
        fontFamily: 'Quicksand',
        // тема для текста в приложении
        textTheme: ThemeData.light().textTheme.copyWith(
            title: TextStyle(fontFamily: 'OpenSans', fontWeight: FontWeight.bold, fontSize: 18.0),
            button: TextStyle(color: Colors.white),
          ),
        // тема для AppBar
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
            title: TextStyle(fontFamily: 'OpenSans', fontWeight: FontWeight.bold, fontSize: 20.0)
          ),
        )
      ),
      home: HomePage(title: 'Personal Expenses'),
    );
  }
}