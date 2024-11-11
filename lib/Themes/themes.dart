import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Colors.white;
  static const Color red = Color.fromARGB(255, 239, 61, 45);
  static const Color inactive = Color.fromARGB(255, 108, 108, 108);
  static const Color inactiveLight = Color.fromARGB(255, 201, 201, 201);
  static const Color black = Colors.black;
  static const Color white = Colors.white;
  static const List<Color> redGradiant = [
    Color.fromRGBO(238, 70, 61, 1),
    Color.fromRGBO(255, 138, 95, 1),
  ];
  static const List<Color> greenGradiant = [
    Color.fromRGBO(75, 237, 188, 1),
    Color.fromRGBO(87, 204, 168, 1),
  ];

  final ThemeData orangeTheme = ThemeData.light().copyWith(
    textTheme: const TextTheme(
      headline1: TextStyle(
        fontFamily: "Centry",
        fontSize: 30,
        fontWeight: FontWeight.w500,
        letterSpacing: -1.5,
        color: black,
      ),
      headline2: TextStyle(
        fontFamily: "Centry",
        fontSize: 28,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.5,
        color: black,
      ),
      headline3: TextStyle(
        fontFamily: "Centry",
        fontSize: 26,
        fontWeight: FontWeight.w400,
        color: black,
      ),
      headline4: TextStyle(
        fontFamily: "Centry",
        fontSize: 24,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        color: black,
      ),
      headline5: TextStyle(
        fontFamily: "Centry",
        fontSize: 22,
        fontWeight: FontWeight.w400,
        color: black,
      ),
      headline6: TextStyle(
        fontFamily: "Centry",
        fontSize: 17,
        fontWeight: FontWeight.w300,
        letterSpacing: 0.15,
        color: black,
      ),
      subtitle1: TextStyle(
        fontFamily: "Centry",
        fontSize: 16,
        fontWeight: FontWeight.w300,
        letterSpacing: 0.15,
        color: black,
      ),
      subtitle2: TextStyle(
        fontFamily: "Centry",
        fontSize: 14,
        fontWeight: FontWeight.w300,
        letterSpacing: 0.1,
        color: black,
      ),
      bodyText1: TextStyle(
        fontFamily: "Centry",
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        color: black,
      ),
      bodyText2: TextStyle(
        fontFamily: "Centry",
        fontSize: 14,
        fontWeight: FontWeight.w200,
        letterSpacing: 0.25,
        color: black,
      ),
      button: TextStyle(
        fontFamily: "Centry",
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 1.25,
        color: black,
      ),
      caption: TextStyle(
        fontFamily: "Centry",
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
        color: black,
      ),
      overline: TextStyle(
        fontFamily: "Centry",
        fontSize: 10,
        fontWeight: FontWeight.w400,
        letterSpacing: 1.5,
        color: black,
      ),
    ),
    primaryColor: Colors.white,
    iconTheme: const IconThemeData(color: primary),
    floatingActionButtonTheme:
        const FloatingActionButtonThemeData(backgroundColor: Colors.white),
  );
}
