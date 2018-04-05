import 'package:flutter/material.dart';
import 'package:mathemagician/problem.dart';
import 'package:mathemagician/settings.dart';
import 'package:mathemagician/settings_view.dart';
import 'package:mathemagician/training.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  final Settings settings = new Settings();

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        'settings': (BuildContext context) => new SettingsView(settings),
      },
      home: new Training(settings),
    );
  }
}