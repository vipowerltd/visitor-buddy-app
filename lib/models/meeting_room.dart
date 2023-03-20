import 'package:flutter/material.dart';

class MeetingRoom {
  final int room_id;
  final int account_id;
  final int tenant_id;
  final int building_id;
  final bool is_open_room;
  final bool occupy_status;
  final bool status;
  final DateTime created_on;
  final int created_by;
  final DateTime updated_on;
  final int updated_by;
  final TimeOfDay opening_time;
  final TimeOfDay closing_time;
  final String room_name;

  MeetingRoom({
    required this.room_id, required this.account_id,
    required this.tenant_id, required this.building_id,
    required this.is_open_room, required this.occupy_status,
    required this.status, required this.created_on,
    required this.created_by, required this.updated_on,
    required this.updated_by, required this.opening_time,
    required this.closing_time, required this.room_name,
  });

  factory MeetingRoom.fromJson(Map<String, dynamic> json) {
    return MeetingRoom(
      room_id: json['room_id'],
      account_id: json['account_id'],
      tenant_id: json['tenant_id'],
      building_id: json['building_id'],
      is_open_room: json['is_open_room'] == 1? true : false,
      occupy_status: json['occupy_status'] == 1? true : false,
      status: json['status'] == 1? true : false,
      created_on: DateTime.parse(json['created_on']),
      created_by: json['created_by'],
      updated_on: DateTime.parse(json['updated_on']),
      updated_by: json['updated_by'],
      opening_time: TimeOfDay(hour:int.parse(json['opening_time'].split(":")[0]),minute: int.parse(json['opening_time'].split(":")[1])),
      closing_time: TimeOfDay(hour:int.parse(json['closing_time'].split(":")[0]),minute: int.parse(json['closing_time'].split(":")[1])),
      room_name: json['room_name'],
    );
  }

  Map<String, dynamic> toJson() => {
    'room_id': room_id,
    'account_id': account_id,
    'tenant_id': tenant_id,
    'building_id': building_id,
    'is_open_room': is_open_room,
    'occupy_status': occupy_status,
    'status': status,
    'created_on': created_on,
    'created_by': created_by,
    'updated_on': updated_on,
    'updated_by': updated_by,
    'opening_time': opening_time,
    'closing_time': closing_time,
    'room_name': room_name,
  };
}