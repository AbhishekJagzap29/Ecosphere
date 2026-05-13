import 'dart:convert';

CustomerRegistrationResponseModel customerRegistrationResponseModelFromJson(
  String str,
) =>
    CustomerRegistrationResponseModel.fromJson(json.decode(str));

String customerRegistrationResponseModelToJson(
  CustomerRegistrationResponseModel data,
) =>
    json.encode(data.toJson());

class CustomerRegistrationResponseModel {
  String? status;
  String? message;
  int? customerId;

  CustomerRegistrationResponseModel({
    this.status,
    this.message,
    this.customerId,
  });

  factory CustomerRegistrationResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final source = json['result'] is Map<String, dynamic>
        ? json['result'] as Map<String, dynamic>
        : json;

    return CustomerRegistrationResponseModel(
      status: _readString(source['status']),
      message: _readString(source['message']),
      customerId: _readInt(source['customer_id']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'customer_id': customerId,
    };
  }
}

int? _readInt(dynamic value) {
  if (value is int) return value;
  if (value is String) return int.tryParse(value);
  return null;
}

String? _readString(dynamic value) {
  if (value is String && value.trim().isNotEmpty) {
    return value.trim();
  }

  return null;
}