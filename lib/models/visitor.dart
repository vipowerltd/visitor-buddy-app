class Visitor {
  final int visitor_id;
  final String name;
  final String email;
  final String phone;
  final String purpose_of_visit;
  final bool disclaimer_accepted;
  final String signature;
  final DateTime sign_in_time;
  final DateTime? sign_out_time;
  final int signed_in_by;
  final int? signed_out_by;
  final String signed_in_method;
  final bool is_pre_registered;
  final int? pre_registered_by;
  final int user_id;
  final int tenant_id;
  final int building_id;
  final int account_id;
  final int visitor_type_id;

  Visitor({
    required this.visitor_id, required this.name,
    required this.email, required this.phone,
    required this.purpose_of_visit, required this.disclaimer_accepted,
    required this.signature, required this.sign_in_time,
    this.sign_out_time, required this.signed_in_by,
    this.signed_out_by, required this.signed_in_method,
    required this.is_pre_registered, this.pre_registered_by,
    required this.user_id, required this.tenant_id,
    required this.building_id, required this.account_id,
    required this.visitor_type_id,
  });

  factory Visitor.fromJson(Map<String, dynamic> json) {
    return Visitor(
      visitor_id: json['visitor_id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      purpose_of_visit: json['purpose_of_visit'],
      disclaimer_accepted: json['disclaimer_accepted'] == 1? true : false,
      signature: json['signature'],
      sign_in_time: DateTime.parse(json['sign_in_time']),
      sign_out_time: json['sign_out_time'] == null? null : DateTime.parse(json['sign_out_time']),
      signed_in_by: json['signed_in_by'],
      signed_out_by: json['signed_out_by'],
      signed_in_method: json['signed_in_method'],
      is_pre_registered: json['is_pre_registered'] == 1? true : false,
      pre_registered_by: json['pre_registered_by'],
      user_id: json['user_id'],
      tenant_id: json['tenant_id'],
      building_id: json['building_id'],
      account_id: json['account_id'],
      visitor_type_id: json['visitor_type_id'],
    );
  }

  Map<String, dynamic> toJson() => {
    'visitor_id': visitor_id,
    'name': name,
    'email': email,
    'phone': phone,
    'purpose_of_visit': purpose_of_visit,
    'disclaimer_accepted': disclaimer_accepted,
    'signature': signature,
    'sign_in_time': sign_in_time,
    'sign_out_time': sign_out_time,
    'signed_in_by': signed_in_by,
    'signed_out_by': signed_out_by,
    'signed_in_method': signed_in_method,
    'is_pre_registered': is_pre_registered,
    'pre_registered_by': pre_registered_by,
    'user_id': user_id,
    'tenant_id': tenant_id,
    'building_id': building_id,
    'account_id': account_id,
    'visitor_type_id': visitor_type_id,
  };
}