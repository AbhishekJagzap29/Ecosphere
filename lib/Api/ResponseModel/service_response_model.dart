import 'dart:convert';

ServiceResponseModel serviceResponseModelFromJson(String str) =>
    ServiceResponseModel.fromJson(json.decode(str));

String serviceResponseModelToJson(ServiceResponseModel data) =>
    json.encode(data.toJson());

class ServiceResponseModel {
  String? status;
  String? message;
  List<ServiceData> data;

  ServiceResponseModel({
    this.status,
    this.message,
    this.data = const [],
  });

  factory ServiceResponseModel.fromJson(Map<String, dynamic> json) {
    return ServiceResponseModel(
      status: json['status'],
      message: json['message'],
      data: json['data'] is List
          ? (json['data'] as List)
              .whereType<Map<String, dynamic>>()
              .map(ServiceData.fromJson)
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data.map((service) => service.toJson()).toList(),
    };
  }
}

class ServiceData {
  int? id;
  String? name;
  String? description;
  String? image;

  ServiceData({
    this.id,
    this.name,
    this.description,
    this.image,
  });

  factory ServiceData.fromJson(Map<String, dynamic> json) {
    return ServiceData(
      id: _readInt(json['id']),
      name: _readString(json['name']),
      description: _readString(json['description']),
      image: _readString(
        json['image'] ??
            json['image_1920'] ??
            json['image_1024'] ??
            json['image_512'] ??
            json['image_256'] ??
            json['image_128'] ??
            json['image_url'] ??
            json['image_base64'] ??
            json['service_image'] ??
            json['category_image'] ??
            json['display_image'] ??
            json['thumbnail'] ??
            json['thumbnail_url'] ??
            json['photo'] ??
            json['icon'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image': image,
    };
  }

  static int? _readInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }

  static String? _readString(dynamic value) {
    if (value is String && value.trim().isNotEmpty) {
      return value.trim();
    }

    return null;
  }
}
