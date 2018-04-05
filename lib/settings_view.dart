import 'package:flutter/material.dart';
import 'package:mathemagician/settings.dart';

class SettingsView extends StatefulWidget {
  final Settings settings;

  SettingsView(this.settings);

  @override
  _SettingsViewState createState() => new _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    Settings settings = widget.settings;
    return new Scaffold(
      appBar: new AppBar(
        actions: <Widget>[
          new FlatButton(
            onPressed: null,
            child: new Icon(Icons.done),
          )
        ],
      ),
      body: new Padding(
        padding: const EdgeInsets.symmetric(vertical: 50.0, horizontal: 30.0),
        child: new Column(
          children: <Widget>[
            new Text('Difficulty'),
            new Slider(
              label: settings.difficulty.val.toString(),
              value: settings.difficulty.val.toDouble(),
              min: settings.difficulty.min.toDouble(),
              max: settings.difficulty.max.toDouble(),
              divisions: settings.difficulty.max - settings.difficulty.min,
              onChanged: (newVal) => setState(() => settings.difficulty.val = newVal.toInt()),
            ),
          ],
        ),
      ),
    );
  }
}
