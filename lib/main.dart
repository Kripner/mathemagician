import 'package:flutter/material.dart';
import 'package:mathemagician/home.dart';
import 'package:mathemagician/problem.dart';
import 'package:mathemagician/settings.dart';
import 'package:mathemagician/settings_view.dart';
import 'package:mathemagician/training.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  final Settings settings = new Settings.defaultValues();

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.orange,
        accentColor: Colors.brown,
      ),
      home: new Home(),
    );
  }
}