import 'dart:developer';

import 'package:visitor_power_buddy/api/delivery_apis.dart';
import 'package:visitor_power_buddy/api/visitor_apis.dart';
import 'package:visitor_power_buddy/models/visitor.dart';

import '../models/delivery.dart';

Future<Map<String, dynamic>> getHomeContent() async {
  List<Visitor> visitorList = [];
  List<Delivery> deliveryList = [];

  log('Getting Visitors');
  visitorList = await getAllVisitors();
  log('Visitors retrieved, getting deliveries');
  deliveryList = await getAllDeliveries();
  log('Deliveries retrieved');

  Map<String, dynamic> result = {
    'visitors': visitorList,
    'deliveries': deliveryList,
  };

  return result;
}