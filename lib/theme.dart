import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

final theme = ThemeData.from(
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan),
).copyWith(
    inputDecorationTheme:
        const InputDecorationTheme(border: OutlineInputBorder()));

const fcpeBlue = Color(0xff292072);

const fcpeGreen = Color(0xff70AF40);

enum TrombiColor {
  yellow(rawYellow),
  green(rawGreen),
  red(rawRed),
  blue(rawBlue),
  orange(rawOrange),
  teal(rawTeal);

  final int rawValue;

  const TrombiColor(this.rawValue);

  Color get color => Color(rawValue);

  Color get lightColor => Color(rawLightColor);

  int get rawLightColor {
    final c = HSLColor.fromColor(color);

    return c.withLightness(.8).toColor().value;
  }

  static List<TrombiColor> refColors = [
    ...List.from(values)..shuffle(),
    ...List.from(values)..shuffle()
  ];
}

const rawYellow = 0xffff8f00;

const rawGreen = 0xff6fae42;

const rawRed = 0xfffc3d46;

const rawBlue = 0xff1c9795;

const rawOrange = 0xfffe7c3c;

const rawTeal = 0xff03a9f4;
