import 'dart:convert';

ExecutiveLoginResponseModel executiveLoginResponseModelFromJson(String str) =>
    ExecutiveLoginResponseModel.fromJson(json.decode(str));

String executiveLoginResponseModelToJson(ExecutiveLoginResponseModel data) =>
    json.encode(data.toJson());

class ExecutiveLoginResponseModel {
  final String? status;
  final String? message;
  final int? userId;
  final String? name;
  final String? login;
  final String? sessionId;
  final Map<String, dynamic>? data;

  const ExecutiveLoginResponseModel({
    this.status,
    this.message,
    this.userId,
    this.name,
    this.login,
    this.sessionId,
    this.data,
  });

  bool get isSuccess => status?.toUpperCase() == 'SUCCESS';

  factory ExecutiveLoginResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    final dataMap = data is Map<String, dynamic> ? data : null;

    return ExecutiveLoginResponseModel(
      status: json['status']?.toString(),
      message: json['message']?.toString(),
      userId: _readInt(json['user_id'] ?? dataMap?['user_id'] ?? dataMap?['id']),
      name: (json['name'] ?? dataMap?['name'])?.toString(),
      login: (json['login'] ?? dataMap?['login'])?.toString(),
      sessionId: (json['session_id'] ?? dataMap?['session_id'])?.toString(),
      data: dataMap,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'user_id': userId,
      'name': name,
      'login': login,
      'session_id': sessionId,
      'data': data,
    };
  }

  static int? _readInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }
}
