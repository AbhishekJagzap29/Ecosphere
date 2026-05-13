import 'dart:convert';

SubServiceResponseModel subServiceResponseModelFromJson(String str) =>
    SubServiceResponseModel.fromJson(json.decode(str));

String subServiceResponseModelToJson(SubServiceResponseModel data) =>
    json.encode(data.toJson());

class SubServiceResponseModel {
  String? status;
  String? message;
  List<SubServiceData> data;

  SubServiceResponseModel({
    this.status,
    this.message,
    this.data = const [],
  });

  factory SubServiceResponseModel.fromJson(Map<String, dynamic> json) {
    return SubServiceResponseModel(
      status: json['status'],
      message: json['message'],
      data: json['data'] is List
          ? (json['data'] as List)
              .whereType<Map<String, dynamic>>()
              .map(SubServiceData.fromJson)
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data.map((subService) => subService.toJson()).toList(),
    };
  }
}

class SubServiceData {
  int? id;
  String? name;
  String? description;

  SubServiceData({
    this.id,
    this.name,
    this.description,
  });

  factory SubServiceData.fromJson(Map<String, dynamic> json) {
    return SubServiceData(
      id: _readInt(json['id']),
      name: _readString(json['name']),
      description: _readString(json['description']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
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
