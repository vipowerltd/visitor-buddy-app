import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart';

import '../models/visitor.dart';
import 'env.dart';

Future<int> getTotalVisitorCount() async {
  log('Called');
  String url = '${Env.URL_PREFIX}/api/post/get_visitors.php';
  var response = await post(Uri.parse(url), headers: {
    'accept': 'application/json',
  }, body: jsonEncode({"user_id": userID})
  );

  log(response.body);

  return json.decode(response.body);
}

Future<List<Visitor>> getAllVisitors() async {
  List<Visitor> list = [];

  String url = '${Env.URL_PREFIX}/api/post/read_all_visitors.php';
  var response = await post(Uri.parse(url), headers: {
    'accept': 'application/json',
  }, body: jsonEncode({"user_id": userID})
  );
  log(response.body);

  var map = json.decode(response.body);
  List<dynamic> data = map['data'];
  log(data[0]['name']);

  for (int i = 0; i < data.length; i++) {
    log('Found visitor');
    Visitor a = Visitor.fromJson(data[i]);
    list.add(a);
  }

  log('List length: ${list.length}');
  return list;
}