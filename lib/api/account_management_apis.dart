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

  log('Response is: ${response.body} \nfgfdgfdgf ${response.request}');

  return response;
}

Future<Response> validateLogin(String email, String password) async {
  String url = '${Env.URL_PREFIX}/api/post/login.php';
  var response = await post(Uri.parse(url), headers: {
    'accept': 'application/json',
  }, body: jsonEncode({"email": email, "password": password})
  );

  log(response.body);

  return response;
}

Future<Map<String, dynamic>> getUserIDs() async {
  String url = '${Env.URL_PREFIX}/api/post/get_user_ids.php';
  var response = await post(Uri.parse(url), headers: {
    'accept': 'application/json',
  }, body: jsonEncode({"user_id": userID})
  );
  log(response.body);
  return json.decode(response.body);
}

Future<Response> setPasswordResetCode(String email, String code) async {
  String url = '${Env.URL_PREFIX}/api/post/set_password_reset_code.php';
  var response = await post(Uri.parse(url), headers: {
    'accept': 'application/json',
  }, body: jsonEncode({"email": email, "reset_code": code})
  );

  log(response.body);

  return response;
}

Future<Response> checkPasswordResetCode(String email, String code) async {
  String url = '${Env.URL_PREFIX}/api/post/check_password_reset_code.php';
  var response = await post(Uri.parse(url), headers: {
    'accept': 'application/json',
  }, body: jsonEncode({"email": email, "reset_code": code})
  );

  log(response.body);

  return response;
}