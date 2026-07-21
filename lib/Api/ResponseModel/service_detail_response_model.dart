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
  List<String> discounts;
  int? subserviceId;
  String? subserviceName;
  int? talukaId;
  String? talukaName;
  String? image;
  List<String> galleryImages;
  List<String> facilities;
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
    this.discounts = const [],
    this.subserviceId,
    this.subserviceName,
    this.talukaId,
    this.talukaName,
    this.image,
    this.galleryImages = const [],
    this.facilities = const [],
    this.youtubeLink,
    this.facebookLink,
    this.instagramLink,
  });

  factory ServiceDetailData.fromJson(Map<String, dynamic> json) {
    final imageList = _readStringList(json['image']);
    final galleryImageList = _readStringList(json['gallery_images']);
    final images = galleryImageList.isNotEmpty ? galleryImageList : imageList;

    return ServiceDetailData(
      id: _readInt(json['id']),
      name: _readString(json['name']),
      owner_id: _readString(json['owner_id']),
      address: _readString(json['address']),
      phone: _readString(json['phone']),
      discount: _readString(json['discount']),
      discounts: _readStringList(json['discounts']),
      subserviceId: _readInt(json['subservice_id']),
      subserviceName: _readString(json['subservice_name']),
      talukaId: _readInt(json['taluka_id']),
      talukaName: _readString(json['taluka_name']),
      image: imageList.isNotEmpty ? imageList.first : null,
      galleryImages: images,
      facilities: _readStringList(json['facilities']),
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
      'discounts': discounts,
      'subservice_id': subserviceId,
      'subservice_name': subserviceName,
      'taluka_id': talukaId,
      'taluka_name': talukaName,
      'image': image,
      'gallery_images': galleryImages,
      'facilities': facilities,
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

  static List<String> _readStringList(dynamic value) {
    if (value is String || value is num) {
      final item = _readString(value);
      return item == null ? [] : [item];
    }

    if (value is! List) return [];

    return value
        .map(_readString)
        .whereType<String>()
        .where((image) => image.isNotEmpty)
        .toList();
  }
}
