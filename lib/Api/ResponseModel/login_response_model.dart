
import 'dart:convert';

LoginResponseModel loginResponseModelFromJson(String str) =>
    LoginResponseModel.fromJson(json.decode(str));

String loginResponseModelToJson(LoginResponseModel data) =>
    json.encode(data.toJson());

class LoginResponseModel {
  String? status;
  String? message;
  int? userId;
  String? name;
  String? login;
  String? sessionId;

  LoginResponseModel({
    this.status,
    this.message,
    this.userId,
    this.name,
    this.login,
    this.sessionId,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    if (json['error'] is Map<String, dynamic>) {
      final error = json['error'] as Map<String, dynamic>;
      final data = error['data'];

      return LoginResponseModel(
        status: 'FAILED',
        message: data is Map<String, dynamic>
            ? data['message'] ?? error['message'] ?? 'Login failed'
            : error['message'] ?? 'Login failed',
      );
    }

    if (json['result'] is Map<String, dynamic>) {
      final result = json['result'] as Map<String, dynamic>;
      final uid = result['uid'];

      return LoginResponseModel(
        status: uid == false || uid == null ? 'FAILED' : 'SUCCESS',
        message: uid == false || uid == null
            ? 'Invalid login or password'
            : 'Login successful',
        userId: uid is int ? uid : null,
        name: result['name'] ?? result['partner_display_name'],
        login: result['username'] ?? result['login'],
        sessionId: result['session_id'],
      );
    }

    return LoginResponseModel(
      status: json['status'],
      message: json['message'],
      userId: json['user_id'],
      name: json['name'],
      login: json['login'],
      sessionId: json['session_id'],
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
    };
  }
}
