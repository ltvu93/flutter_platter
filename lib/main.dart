import 'package:flutter_platter/styles.dart';
import 'package:flutter_web/material.dart';

import 'main_page.dart';

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
