import 'package:flutter/material.dart';
import 'package:mathemagician/settings.dart';
import 'package:mathemagician/settings_storage.dart';
import 'package:mathemagician/training.dart';
import 'package:mathemagician/utils.dart';

class Home extends StatefulWidget {
  final SettingsStorage _settingsStorage = new SettingsStorage();

  @override
  _HomeState createState() => new _HomeState();
}

class _HomeState extends State<Home> {
  Settings _settings;

  @override
  void initState() {
    super.initState();
    widget._settingsStorage.load().catchError((e) {
      print('Couldn\'t load settings: ' + e);
      setState(() {
        _settings = new Settings.defaultValues(storage: widget._settingsStorage);
      });
    }).then((Settings loadedSettings) {
      print('Settings loaded successfully');
      setState(() {
        _settings = loadedSettings;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new FlatButton(onPressed: startTraining, child: new Text('Train!')),
            _buildStats(),
          ],
        ),
      ),
    );
  }

  Widget _buildStats() {
    return new Column(
      children: <Widget>[
        new Text('You have earned'),
        _settings == null ? new CircularProgressIndicator() : new Text(_settings.batchesSolved.val.toString()),
        new Text('rainbows so far!'),
      ],
    );
  }

  void startTraining() {
    if (_settings == null) {
      showTextSnackBar(context, 'Please wait until your settings are loaded');
      return;
    }
    Navigator.push(
      context,
      new MaterialPageRoute(builder: (context) => new Training(_settings)),
    );
  }
}
