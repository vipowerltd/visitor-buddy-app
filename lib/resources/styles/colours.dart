import 'dart:ui';

import 'package:flutter/material.dart';

Color appBackgroundColour = const Color.fromRGBO(245, 245, 245, 1);

Color mainColour = const Color.fromRGBO(1, 95, 126, 1);

Color mainColourLight = const Color.fromRGBO(6, 129, 168, 1);

Color fadedColour = Colors.black38;

Color altColour = const Color.fromRGBO(226, 249, 198, 1);

Color lightGreen = const Color.fromRGBO(9, 123, 131, 1);

Color mainBlue = const Color.fromRGBO(2, 123, 210, 1);

Color lightMainBlue = const Color.fromRGBO(6, 129, 168, 1);

Color paleBlue = const Color.fromRGBO(233, 250, 255, 1);

//GRADIENTS
LinearGradient blueGradientBack = LinearGradient(
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
  colors: [
    mainColour,
    mainColourLight
  ]
);

LinearGradient blueGradientLight = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      mainColour,
      lightMainBlue
    ]
);

LinearGradient whiteGradient = const LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    Colors.white10,
    Colors.white,
  ]
);