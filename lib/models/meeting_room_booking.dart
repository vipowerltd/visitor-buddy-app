class MeetingRoomBooking {
  final int booking_id;
  final DateTime start_time;
  final DateTime end_time;
  final int room_id;
  final int user_id;
  final DateTime booked_on;
  final String booking_name;

  MeetingRoomBooking({
    required this.booking_id, required this.start_time,
    required this.end_time, required this.room_id,
    required this.user_id, required this.booked_on,
    required this.booking_name,
  });

  factory MeetingRoomBooking.fromJson(Map<String, dynamic> json) {
    return MeetingRoomBooking(
      booking_id: json['booking_id'],
      start_time: DateTime.parse(json['start_time']),
      end_time: DateTime.parse(json['end_time']),
      room_id: json['room_id'],
      user_id: json['user_id'],
      booked_on: DateTime.parse(json['booked_on']),
      booking_name: json['booking_name'],
    );
  }

  Map<String, dynamic> toJson() => {
    'booking_id': booking_id,
    'start_time': start_time.toIso8601String(),
    'end_time': end_time.toIso8601String(),
    'room_id': room_id,
    'user_id': user_id,
    'booked_on': booked_on.toIso8601String(),
    'booking_name': booking_name,
  };
}