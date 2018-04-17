import 'package:flutter/material.dart';

class MathExpression {
  final String text;
  final String superscript;

  MathExpression(this.text, {this.superscript});

  Widget createExpression({TextStyle style}) {
    if (superscript == null) return new Text(text, style: style);
    return new TextWithSuperscript(this, style: style);
  }
}

class TextWithSuperscript extends StatelessWidget {
  final MathExpression expression;
  final TextStyle style;

  TextWithSuperscript(this.expression, {this.style});

  @override
  Widget build(BuildContext context) {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        new Text(
          expression.text,
          style: style,
        ),
        new Text(expression.superscript,
            style: style == null ? new TextStyle(fontSize: 10.0) : style.copyWith(fontSize: 10.0)),
      ],
    );
  }
}
