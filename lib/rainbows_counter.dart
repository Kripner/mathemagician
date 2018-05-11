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
          width: 2.5,
        ),
      ),
      child: new Center(
        child: new RichText(
            textAlign: TextAlign.center,
            text: new TextSpan(
              text: rainbow + '\n',
              style: textStyle.copyWith(fontSize: 15.0),
              children: <TextSpan>[
                new TextSpan(
                  text: rainbowsCount.toString(),
                  style: textStyle.copyWith(fontSize: 20.0),
                )
              ],
            )),
      ),
    );
  }
}
