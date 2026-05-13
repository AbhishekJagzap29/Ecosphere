import 'dart:convert';

TalukaResponseModel talukaResponseModelFromJson(String str) =>
    TalukaResponseModel.fromJson(json.decode(str));

String talukaResponseModelToJson(TalukaResponseModel data) =>
    json.encode(data.toJson());

class TalukaResponseModel {
  String? status;
  String? message;
  List<TalukaData> data;

  TalukaResponseModel({
    this.status,
    this.message,
    this.data = const [],
  });

  factory TalukaResponseModel.fromJson(Map<String, dynamic> json) {
    return TalukaResponseModel(
      status: _readString(json['status']),
      message: _readString(json['message']),
      data: json['data'] is List
          ? (json['data'] as List)
              .whereType<Map<String, dynamic>>()
              .map(TalukaData.fromJson)
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data.map((taluka) => taluka.toJson()).toList(),
    };
  }
}

class TalukaData {
  int? id;
  String? name;

  TalukaData({
    this.id,
    this.name,
  });

  factory TalukaData.fromJson(Map<String, dynamic> json) {
    return TalukaData(
      id: _readInt(json['id']),
      name: _readString(json['name']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  static int? _readInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }
}

String? _readString(dynamic value) {
  if (value is String && value.trim().isNotEmpty) {
    return value.trim();
  }

  return null;
}