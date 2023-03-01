import 'package:flutter/material.dart';

import '../styles/textstyles.dart';

//This image string should be swapped with the image this user has uploaded for their profile
String userImagePath = 'assets/images/default_user.png';
//This string is replaced by the name of the logged in user retrieved from the database
String userName = 'John Doe';

Widget userWidget() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Container(
        height: 50,
        child: Image(
          image: AssetImage(
              userImagePath
          ),
        ),
      ),
      const SizedBox(width: 12.0,),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hello',
            style: titleHeadTextLight,
          ),
          Text(
            userName,
            style: titleHeadText,
          )
        ],
      )
    ],
  );
}