import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../../api/read_data.dart';
import '../styles/textstyles.dart';

//This image string should be swapped with the image this user has uploaded for their profile
String userImagePath = 'assets/images/default_user.png';
//This string is replaced by the name of the logged in user retrieved from the database
String userName = 'John Doe';

Widget userWidget() {
  return FutureBuilder(
    future: getName(),
    builder: (BuildContext context, AsyncSnapshot snapshot) {
      if (!snapshot.hasData) {
        return CircularProgressIndicator();
      }
      else {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 50,
              child: CircleAvatar(
                radius: 25,
                backgroundImage: snapshot.data['image'] != null? NetworkImage(
                  snapshot.data['image'],
                ) : Image.asset('assets/images/default_user.png').image,
              )
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
                  snapshot.data['name'],
                  style: titleHeadText,
                )
              ],
            )
          ],
        );
      }
    },
  );
}

//Future builder that calls getName() to display the user's name at the top of the page
//Could adapt the php method to also return the URL for the user's display photo and then show it in the assetimage location
