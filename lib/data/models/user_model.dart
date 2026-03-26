class UserModel {
  final String firebaseUid;
  final String name;
  final String email;
  final String phone;
  final String role;
  final int status;
  final double? lat;
  final double? lng;
  final String? license;
  final double? ratingAvg;

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
    this.license,
    this.ratingAvg,
    this.location,
    this.timeOpen,
    this.vehicleNumber,
    this.image,
    this.lng,
    this.lat,
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
      license: json['license'],
      ratingAvg: json['rating_avg'] != null
          ? double.tryParse(json['rating_avg'].toString())
          : null,
      vehicleNumber: json['vehicle_number'],
      image: json['image'],

      lat: json['lat'] != null
          ? double.tryParse(json['lat'].toString())
          : null,

      lng: json['lng'] != null
          ? double.tryParse(json['lng'].toString())
          : null,
    );
  }

  Map<String, String> toFields() {
    return {
      if (id != null) 'id': id.toString(),

      'role': role,
      'name': name,
      'email': email,
      'phone': phone,

      'name_ar': nameAr ?? '',
      'location': location ?? '',
      'time_open': timeOpen ?? '',

      if (lat != null) 'lat': lat.toString(),
      if (lng != null) 'lng': lng.toString(),

      'vehicle_number': vehicleNumber ?? '',
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

