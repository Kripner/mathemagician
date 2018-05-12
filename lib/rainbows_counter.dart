import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mathemagician/utils.dart';

class RainbowCounter extends StatelessWidget {
  static const double DIAMETER = 50.0;
  final int rainbowsCount;

  const RainbowCounter({Key key, this.rainbowsCount}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.body1;
    return new Container(
      width: RainbowCounter.DIAMETER,
      height: RainbowCounter.DIAMETER,
      decoration: new BoxDecoration(
        shape: BoxShape.circle,
        border: new Border.all(
          color: Theme.of(context).primaryColor,
          width: 1.5,
        ),
      ),
      child: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Transform.rotate(
              angle: pi/4,
              child: new Text(rainbow, style: textStyle.copyWith(fontSize: 13.0)),
            ),
            new Text(rainbowsCount.toString(), style: textStyle.copyWith(fontSize: 20.0)),
          ],
        ),
      ),
    );
  }
}