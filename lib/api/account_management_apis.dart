import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart';
import 'package:visitor_power_buddy/models/user.dart';

import 'env.dart';

Future<Response> addUser(User user) async {
  String url = '${Env.URL_PREFIX}/api/post/create_t.php';
  var response = await post(Uri.parse(url), headers: {
    'content-type': 'application/json', 'accept': 'application/json'
  },body: jsonEncode(user.toJson()));

  log('Response code: ${response.statusCode}');
  log('Response: ${response.body}');
  log('Reason: ${response.reasonPhrase}');

  return response;
}

Future<Response> validateLogin(String email, String password) async {
  String url = '${Env.URL_PREFIX}/api/post/login.php';
  var response = await post(Uri.parse(url), headers: {
    'accept': 'application/json',
  }, body: jsonEncode({"email": email, "password": password})
  );

  return response;
}