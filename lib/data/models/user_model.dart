class UserModel {
  final String firebaseUid;
  final String name;
  final String email;
  final String phone;
  final String role;
  final int status;

  final int? id;
  final String? nameAr;
  final String? location;
  final String? timeOpen;
  final String? vehicleNumber;
  final String? image;

  UserModel({
    required this.firebaseUid,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.status,
    this.id,
    this.nameAr,
    this.location,
    this.timeOpen,
    this.vehicleNumber,
    this.image,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      firebaseUid: json['firebase_uid'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      role: json['role'] ?? '',
      status: int.tryParse(json['status'].toString()) ?? 0,
      id: json['id'] != null ? int.tryParse(json['id'].toString()) : null,
      nameAr: json['name_ar'],
      location: json['location'],
      timeOpen: json['time_open'],
      vehicleNumber: json['vehicle_number'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() => {
    'firebase_uid': firebaseUid,
    'name': name,
    'email': email,
    'phone': phone,
    'role': role,
    'status': status,

    'id': id,
    'name_ar': nameAr,
    'location': location,
    'time_open': timeOpen,
    'vehicle_number': vehicleNumber,
    'image': image,
  };
  Map<String, String> toFields() {
    return {
      if (id != null) 'id': id.toString(),
      'role': role,
      'name': name,
      'email': email,
      'phone': phone,
      if (nameAr != null) 'name_ar': nameAr!,
      if (location != null) 'location': location!,
      if (timeOpen != null) 'time_open': timeOpen!,
      if (vehicleNumber != null) 'vehicle': vehicleNumber!,
    };
  }
}


class SearchUserModel {
  final int id;
  final String name;
  final String? email;
  final String? phone;
  final String type;

  SearchUserModel({
    required this.id,
    required this.name,
    this.email,
    this.phone,
    required this.type,
  });

  factory SearchUserModel.fromJson(Map<String, dynamic> json) {
    return SearchUserModel(
      id: int.parse(json['id'].toString()),
      name: json['name'] ?? '',
      email: json['email'],
      phone: json['phone'],
      type: json['type'] ?? '',
    );
  }
}

