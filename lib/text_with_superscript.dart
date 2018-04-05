import 'package:flutter/material.dart';

class TextWithSuperscript extends StatelessWidget {
  final String _baseText;
  final String _superscript;

  TextWithSuperscript(this._baseText, this._superscript);

  @override
  Widget build(BuildContext context) {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        new Text(_baseText),
        new Text(_superscript, style: new TextStyle(fontSize: 10.0)),
      ],
    );
  }
}
