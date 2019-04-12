import 'package:flutter/material.dart';
import 'package:flutter_platter/main_page.dart';
import 'package:flutter_platter/styles.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Platter',
      theme: new ThemeData(
        primaryColor: primaryColor,
        primaryColorDark: primaryDarkColor,
        accentColor: accentColor,
      ),
      home: new MainPage(),
    );
  }
}
