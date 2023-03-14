//ADAPT THIS FOR DELIVERIES
import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart';
import 'package:visitor_power_buddy/models/delivery.dart';

import 'env.dart';

Future<List<Delivery>> getAllDeliveries() async {
  List<Delivery> list = [];

  String url = '${Env.URL_PREFIX}/api/post/read_all_deliveries.php';
  var response = await post(Uri.parse(url), headers: {
    'accept': 'application/json',
  }, body: jsonEncode({"user_id": userID})
  );
  log(response.body);

  var map = json.decode(response.body);
  List<dynamic> data = map['data'];

  for (int i = 0; i < data.length; i++) {
    log('Found delivery');
    Delivery a = Delivery.fromJson(data[i]);
    list.add(a);
  }

  log('List length: ${list.length}');
  return list;
}