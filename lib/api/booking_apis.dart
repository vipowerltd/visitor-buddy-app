import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';

import '../models/meeting_room.dart';
import '../models/meeting_room_booking.dart';
import 'env.dart';

Future<List<MeetingRoom>> getMeetingRooms(BuildContext context, String user_id) async {
  List<MeetingRoom> list = [];

  String url = '${Env.URL_PREFIX}/api/post/get_meeting_rooms.php';
  var response = await post(Uri.parse(url), headers: {
    'accept': 'application/json',
  }, body: jsonEncode({"user_id": userID})
  );
  log(response.body);

  var map = json.decode(response.body);
  List<dynamic> data = map['data'];

  for (int i = 0; i < data.length; i++) {
    log('Found meeting room');
    MeetingRoom a = MeetingRoom.fromJson(data[i]);
    list.add(a);
  }

  log('List length: ${list.length}');
  return list;
}

Future<bool> addMeetingBooking(BuildContext context, MeetingRoomBooking booking) async {
  String url = '${Env.URL_PREFIX}/api/post/insert_meetingroom_booking.php';
  var response = await post(Uri.parse(url), headers: {
    'content-type': 'application/json', 'accept': 'application/json'
  },body: jsonEncode(booking.toJson()));
  log('Response: ${response.body}');
  var result = json.decode(response.body);

  if (result['message'].contains('Created')) {
    return true;
  }
  else {
    return false;
  }
}

Future<List<MeetingRoomBooking>> getAllBookings() async {
  List<MeetingRoomBooking> list = [];

  String url = '${Env.URL_PREFIX}/api/post/get_bookings.php';
  var response = await post(Uri.parse(url), headers: {
    'accept': 'application/json',
  }, body: jsonEncode({"user_id": userID})
  );
  log(response.body);

  var map = json.decode(response.body);
  List<dynamic> data = map['data'];

  for (int i = 0; i < data.length; i++) {
    log('Found meeting room');
    MeetingRoomBooking a = MeetingRoomBooking.fromJson(data[i]);
    list.add(a);
  }

  log('List length: ${list.length}');
  return list;
}