class UserModel {
  final String firebaseUid;
  final String name;
  final String email;
  final String phone;
  final String role;
  final int status;

  UserModel({
    required this.firebaseUid,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.status,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      firebaseUid: json['firebase_uid'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      role: json['role'] ?? '',
      status: json['status'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'firebase_uid': firebaseUid,
    'name': name,
    'email': email,
    'phone': phone,
    'role': role,
    'status': status,
  };
}
