import 'dart:convert';

CreateServiceRequestResponseModel createServiceRequestResponseModelFromJson(
  String str,
) =>
    CreateServiceRequestResponseModel.fromJson(json.decode(str));

String createServiceRequestResponseModelToJson(
  CreateServiceRequestResponseModel data,
) =>
    json.encode(data.toJson());

class CreateServiceRequestResponseModel {
  final String? status;
  final String? message;
  final int? requestId;

  const CreateServiceRequestResponseModel({
    this.status,
    this.message,
    this.requestId,
  });

  bool get isSuccess => status?.toUpperCase() == 'SUCCESS';

  factory CreateServiceRequestResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return CreateServiceRequestResponseModel(
      status: json['status']?.toString(),
      message: json['message']?.toString(),
      requestId: _readInt(json['request_id']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'request_id': requestId,
    };
  }

  static int? _readInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }
}
