import 'package:flutter/material.dart';

class MathExpression {
  final String text;
  final String superscript;

  MathExpression(this.text, {this.superscript});

  Widget createExpression({TextStyle style}) {
    if (superscript == null) return new Text(text, style: style);
    return new TextWithSuperscript(text, superscript);
  }
}

class TextWithSuperscript extends StatelessWidget {
  final String _baseText;
  final String _superscript;

  TextWithSuperscript(this._baseText, this._superscript);

  @override
  Widget build(BuildContext context) {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        new Text(_baseText),
        new Text(_superscript, style: new TextStyle(fontSize: 10.0)),
      ],
    );
  }
}
