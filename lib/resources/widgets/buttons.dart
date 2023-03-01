import 'package:flutter/material.dart';

import '../styles/colours.dart';
import '../styles/textstyles.dart';

Container mainButton(String title) {
  return Container(
    padding: const EdgeInsets.all(12.0),
    decoration: BoxDecoration(
      color: mainColour,
      borderRadius: BorderRadius.circular(5),
    ),
    child: Text(
      title,
      style: buttonText,
    ),
  );
}