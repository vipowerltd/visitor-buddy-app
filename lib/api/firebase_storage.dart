import 'dart:developer';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:visitor_power_buddy/api/env.dart';

Future<String?> uploadGuestImageToFirebaseStorage(BuildContext context, File selectedImage, String visitor_id) async {
  final dest = '$userID/$visitor_id';
  String? url = null;

  try {
    final ref = FirebaseStorage.instance.ref(dest).child('visitor_image');
    await ref.putFile(selectedImage);
    url = await ref.getDownloadURL();
  } catch (e) {
    log('Firebase Error: $e');
  }

  log(url!);
  return url;
}