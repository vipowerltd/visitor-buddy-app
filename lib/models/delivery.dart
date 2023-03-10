class Delivery {
  final int delivery_id;
  final DateTime arrival_time;
  final DateTime? collected_time;
  final String? qr_code_value;
  final bool claim_status;
  final int dropped_in_by;
  final String? delivery_image;
  final int user_id;
  final int tenant_id;
  final int building_id;
  final int account_id;

  Delivery({
    required this.delivery_id, required this.arrival_time,
    this.collected_time, this.qr_code_value,
    required this.claim_status, required this.dropped_in_by,
    this.delivery_image, required this.user_id,
    required this.tenant_id, required this.building_id,
    required this.account_id,
  });

  factory Delivery.fromJson(Map<String, dynamic> json) {
    return Delivery(
      delivery_id: json['delivery_id'],
      arrival_time: DateTime.parse(json['arrival_time']),
      collected_time: json['collected_time'] == null? null : DateTime.parse(json['collected_time']),
      qr_code_value: json['qr_code_value'],
      claim_status: json['claim_status'] == 1? true : false,
      dropped_in_by: json['dropped_in_by'],
      delivery_image: json['delivery_image'],
      user_id: json['user_id'],
      tenant_id: json['tenant_id'],
      building_id: json['building_id'],
      account_id: json['account_id'],
    );
  }

  Map<String, dynamic> toJson() => {
    'delivery_id': delivery_id,
    'arrival_time': arrival_time,
    'collected_time': collected_time,
    'qr_code_value': qr_code_value,
    'claim_status': claim_status,
    'dropped_in_by': dropped_in_by,
    'delivery_image': delivery_image,
    'user_id': user_id,
    'tenant_id': tenant_id,
    'building_id': building_id,
    'account_id': account_id,
  };
}