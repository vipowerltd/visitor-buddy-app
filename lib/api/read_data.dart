import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart';

import 'env.dart';

Future<Map> getName() async {
  log('Called');
  String url = '${Env.URL_PREFIX}/api/post/get_name.php';
  var response = await post(Uri.parse(url), headers: {
    'accept': 'application/json',
  }, body: jsonEncode({"user_id": userID})
  );

  log(response.body);

  return json.decode(response.body);
}