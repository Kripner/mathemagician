import 'package:flutter/material.dart';
import 'package:mathemagician/colors.dart';
import 'package:mathemagician/home.dart';
import 'package:mathemagician/settings.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  final Settings settings = new Settings.defaultValues();

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
//      theme: new ThemeData(
//        brightness: Brightness.light,
//        primarySwatch: Colors.cyan,
//        accentColor: Colors.cyan[600],
//      ),
      theme: _buildTheme(),
      home: new Home(),
    );
  }

  ThemeData _buildTheme() {
    ThemeData base = new ThemeData.light();
    return base.copyWith(
        primaryColor: primaryColor,
        primaryTextTheme: _buildTextTheme(base.primaryTextTheme, secondaryColor),
        primaryIconTheme: base.primaryIconTheme.copyWith(color: secondaryColor),
        buttonColor: buttonColor,
        buttonTheme: base.buttonTheme.copyWith(
          textTheme: ButtonTextTheme.primary,
        ),
        sliderTheme: base.sliderTheme.copyWith(
          overlayColor: sliderInactiveColor,
          thumbColor: sliderActiveColor,
          activeTrackColor: sliderActiveColor,
          inactiveTrackColor: sliderInactiveColor,
          activeTickMarkColor: sliderTicksActiveColor,
          inactiveTickMarkColor: sliderInactiveColor,
          valueIndicatorColor: sliderActiveColor
        ),
        accentColor: secondaryColor,
        scaffoldBackgroundColor: backgroundColor,
        accentTextTheme: _buildTextTheme(base.accentTextTheme, secondaryColor),
        textTheme: _buildTextTheme(base.textTheme, secondaryColor));
  }

  TextTheme _buildTextTheme(TextTheme base, Color color) {
    return base
        .copyWith(
          headline: base.headline.copyWith(
            fontWeight: FontWeight.w500,
          ),
        )
        .apply(
//          fontFamily: '',
          displayColor: color,
          bodyColor: color,
        );
  }
}
