import 'package:flutter/material.dart';
import 'package:mathemagician/math_net.dart';
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
    widget._settingsStorage.load().then((Settings loadedSettings) {
      print('Settings loaded successfully');
      setState(() {
        _settings = loadedSettings;
      });
    }, onError: (e) {
      print('Loading settings failed: ' + e.toString());
      setState(() {
        _settings = new Settings.defaultValues(storage: widget._settingsStorage);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return new Scaffold(
      body: new CustomPaint(
        painter: new MathNet(const EdgeInsets.symmetric(vertical: 0.3, horizontal: 0.25)),
        child: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Text('Mathemagics!', style: theme.textTheme.title),
              new Text('The art of mental math'),
              new Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: new OutlineButton(onPressed: startTraining, child: new Text('Train!')),
              ),
              _buildStats(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStats() {
    if (_settings == null) return new Container();
    return new Text(_settings.rainbows.val.toString() + ' ' + rainbow);
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
