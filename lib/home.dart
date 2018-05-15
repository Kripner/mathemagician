import 'package:flutter/material.dart';
import 'package:mathemagician/about.dart';
import 'package:mathemagician/colors.dart';
import 'package:mathemagician/math_net.dart';
import 'package:mathemagician/rainbows_counter.dart';
import 'package:mathemagician/settings.dart';
import 'package:mathemagician/settings_storage.dart';
import 'package:mathemagician/training.dart';
import 'package:mathemagician/user_suggestion.dart';
import 'package:mathemagician/utils.dart';

import 'package:share/share.dart';

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
        painter: new MathNet(const EdgeInsets.fromLTRB(0.25, 0.27, 0.25, 0.25)),
        child: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Text('Mathemagics!', style: theme.textTheme.headline),
              new Text('The art of mental math', style: theme.textTheme.subhead),
              new Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: _buildTrainButton(),
              ),
              _buildStats(),
              new Padding(
                child: _buildBottomActions(),
                padding: const EdgeInsets.only(top: 30.0),
              ),
            ],
          ),
        ),
      ),
    );
  }

  OutlineButton _buildTrainButton() {
    return new OutlineButton(
      shape: BeveledRectangleBorder(
        borderRadius: new BorderRadius.all(new Radius.circular(5.0)),
      ),
      onPressed: _startTraining,
      child: new Padding(
        padding: const EdgeInsets.symmetric(horizontal: 17.0, vertical: 11.0),
        child: new Text(
          'Train!',
          style: Theme.of(context).textTheme.button.copyWith(fontSize: 20.0),
        ),
      ),
    );
  }

  Widget _buildStats() {
    return new UserSuggestionOptional(
      child: new Hero(
        child: new RainbowCounter(rainbowsCount: _settings?.rainbows?.val),
        tag: 'rainbow-counter',
      ),
      text: 'Start training to get some rainbows!',
      showText: _settings == null ? false : _settings.problemsSolved.val == 0,
    );
  }

  Widget _buildBottomActions() {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new IconButton(
          onPressed: _initShare,
          icon: new Icon(Icons.share),
        ),
        new IconButton(
          onPressed: _showAbout,
          icon: new Icon(Icons.info_outline),
        ),
      ],
    );
  }

  void _startTraining() {
    if (_settings == null) {
      showTextSnackBar(context, 'Please wait until your settings are loaded');
      return;
    }
    Navigator.of(context).push(new PageRouteBuilder(
          pageBuilder: (_, __, ___) => new Training(_settings),
        ));
  }

  void _initShare() {
    share('Check out the Mathemagician app'); // TODO: google store url
  }

  void _showAbout() async {
    await Navigator.push(
      context,
      new MaterialPageRoute(builder: (context) => new About()),
    );
  }
}
