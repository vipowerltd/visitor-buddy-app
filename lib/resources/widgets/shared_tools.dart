import 'package:flutter/material.dart';
import 'package:visitor_power_buddy/resources/styles/colours.dart';
import 'package:visitor_power_buddy/resources/styles/textstyles.dart';

void showSnackBar(BuildContext context, String content) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        padding: const EdgeInsets.all(12.0),
        backgroundColor: mainColour,
        content: Text(
          content,
          style: titleHeadTextWhite,
        ),
      )
  );
}

bool emailValid(String email) {
  return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
}