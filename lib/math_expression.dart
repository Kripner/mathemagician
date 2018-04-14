import 'package:flutter/material.dart';
import 'package:mathemagician/text_with_superscript.dart';

// TODO: merge with TextWithSuperscript
class MathExpression {
  final String text;
  final String superscript;

  MathExpression(this.text, {this.superscript});

  Widget createExpression() {
    if (superscript == null) return new Text(text);
    return new TextWithSuperscript(text, superscript);
  }
}