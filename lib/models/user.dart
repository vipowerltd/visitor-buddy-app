class User {
  final int user_id;
  final String email;
  final String password;
  final String user_type;
  final DateTime created_on;
  final DateTime? updated_on;
  final DateTime? last_login;
  final int? created_by;
  final String? image_url;
  final bool status;
  final bool is_first_login;
  final String? reset_code;
  final int tenant_id;
  final int? building_id;
  final int? account_id;


  User({
    required this.user_id, required this.email, required this.password,
    required this.user_type, required this.created_by,
    required this.created_on, required this.updated_on,
    required this.last_login, required this.image_url,
    required this.status, required this.is_first_login,
    required this.reset_code, required this.tenant_id,
    required this.building_id, required this.account_id,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      user_id: json['user_id'],
      email: json['email'],
      password: json['password'],
      user_type: json['user_type'],
      created_on: json['created_on'],
      updated_on: json['updated_on'],
      last_login: json['last_login'],
      created_by: json['created_by'],
      image_url: json['image_url'],
      status: json['status'],
      is_first_login: json['is_first_login'],
      reset_code: json['reset_code'],
      tenant_id: json['tenant_id'],
      building_id: json['building_id'],
      account_id: json['account_id']
    );
  }

  Map<String, dynamic> toJson() => {
    'user_id': user_id,
    'email': email,
    'password': password,
    'user_type': user_type,
    'created_on': created_on.toIso8601String(),
    'updated_on': updated_on == null? null : updated_on!.toIso8601String(),
    'last_login': last_login == null? null : last_login!.toIso8601String(),
    'created_by': created_by,
    'image_url': image_url,
    'status': status,
    'is_first_login': is_first_login,
    'reset_code': reset_code,
    'tenant_id': tenant_id,
    'building_id': building_id == null? null : building_id,
    'account_id': account_id == null? null : account_id,
  };
}