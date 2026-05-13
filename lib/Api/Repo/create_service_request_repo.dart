import 'dart:developer';

import 'package:echosphere/Api/ResponseModel/create_service_request_response_model.dart';
import 'package:echosphere/Api/Services/api_services.dart';
import 'package:echosphere/Api/Services/base_service.dart';
import 'package:echosphere/View/Constant/shared_prefs.dart';

class CreateServiceRequestRepo {
  Map<String, String> get header {
    final sessionId = preferences.getString(SharedPreference.sessionId);
    final sessionCookie = _sessionCookie(sessionId);

    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      if (sessionCookie != null) 'Cookie': sessionCookie,
    };
  }

  Future<CreateServiceRequestResponseModel> create({
    required Map<String, dynamic> body,
  }) async {
    final response = await APIService().getResponse(
      url: ApiRouts.createServiceRequestAPI,
      apiType: APIType.aPost,
      body: body,
      header: header,
    );

    log('createServiceRequestResponse >>> $response');

    return CreateServiceRequestResponseModel.fromJson(response);
  }

  String? _sessionCookie(String? sessionId) {
    final value = sessionId?.trim();
    if (value == null || value.isEmpty) return null;
    if (value.contains('=')) return value.split(';').first;
    return 'session_id=$value';
  }
}
