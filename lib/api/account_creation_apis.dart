import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart';
import 'package:visitor_power_buddy/models/user.dart';

import 'env.dart';

addUser(User user) async {
  String url = '${Env.URL_PREFIX}/api/post/create_t.php';
  var response = await post(Uri.parse(url), headers: {
    'content-type': 'application/json', 'accept': 'application/json'
  },body: jsonEncode(user.toJson()));
  log(response.statusCode.toString());
}