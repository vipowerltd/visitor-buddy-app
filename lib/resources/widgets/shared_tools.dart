import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:visitor_power_buddy/resources/styles/colours.dart';
import 'package:visitor_power_buddy/resources/styles/textstyles.dart';
import 'dart:math' as m;
import 'package:encrypt/encrypt.dart' as e;

import '../../api/env.dart';

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

int generateRandomString() {
  int len = 6;
  var r = m.Random();
  const _chars = '1234567890';
  return int.parse(List.generate(len, (index) => _chars[r.nextInt(_chars.length)]).join());
}

String encryptPassword(String plaintext) {
  final key = e.Key.fromUtf8(keyString);
  final iv = e.IV.fromLength(16);

  final encrypter = e.Encrypter(e.AES(key));
  return encrypter.encrypt(plaintext, iv: iv).base64;
}

void loadingDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Center(child: const CircularProgressIndicator());
    }
  );
}

//Fix format
DateFormat formatter = DateFormat('hh:mm a dd/MM/yyyy');