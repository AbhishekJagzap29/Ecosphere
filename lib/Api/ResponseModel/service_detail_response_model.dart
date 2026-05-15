import 'dart:convert';

ServiceDetailResponseModel serviceDetailResponseModelFromJson(String str) =>
    ServiceDetailResponseModel.fromJson(json.decode(str));

String serviceDetailResponseModelToJson(ServiceDetailResponseModel data) =>
    json.encode(data.toJson());

class ServiceDetailResponseModel {
  String? status;
  String? message;
  List<ServiceDetailData> data;

  ServiceDetailResponseModel({
    this.status,
    this.message,
    this.data = const [],
  });

  factory ServiceDetailResponseModel.fromJson(Map<String, dynamic> json) {
    return ServiceDetailResponseModel(
      status: json['status'],
      message: json['message'],
      data: json['data'] is List
          ? (json['data'] as List)
              .whereType<Map<String, dynamic>>()
              .map(ServiceDetailData.fromJson)
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data.map((detail) => detail.toJson()).toList(),
    };
  }
}

class ServiceDetailData {
  int? id;
  String? name;
  String? owner_id;
  String? address;
  String? phone;
  String? discount;
  int? subserviceId;
  String? subserviceName;
  String? image;
  String? youtubeLink;
  String? facebookLink;
  String? instagramLink;

  ServiceDetailData({
    this.id,
    this.name,
    this.owner_id,
    this.address,
    this.phone,
    this.discount,
    this.subserviceId,
    this.subserviceName,
    this.image,
    this.youtubeLink,
    this.facebookLink,
    this.instagramLink,
  });

  factory ServiceDetailData.fromJson(Map<String, dynamic> json) {
    return ServiceDetailData(
      id: _readInt(json['id']),
      name: _readString(json['name']),
      owner_id: _readString(json['owner_id']),
      address: _readString(json['address']),
      phone: _readString(json['phone']),
      discount: _readString(json['discount']),
      subserviceId: _readInt(json['subservice_id']),
      subserviceName: _readString(json['subservice_name']),
      image: _readString(json['image']),
      youtubeLink: _readString(json['youtube_link']),
      facebookLink: _readString(json['facebook_link']),
      instagramLink: _readString(json['instagram_link']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'owner_id': owner_id,
      'address': address,
      'phone': phone,
      'discount': discount,
      'subservice_id': subserviceId,
      'subservice_name': subserviceName,
      'image': image,
      'youtube_link': youtubeLink,
      'facebook_link': facebookLink,
      'instagram_link': instagramLink,
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

    if (value is num) return value.toString();

    return null;
  }
}
