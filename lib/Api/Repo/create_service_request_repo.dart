import 'dart:developer';

import 'package:echosphere/Api/ResponseModel/create_service_request_response_model.dart';
import 'package:echosphere/Api/Services/api_services.dart';
import 'package:echosphere/Api/Services/base_service.dart';
import 'package:echosphere/View/Constant/shared_prefs.dart';

class CreateServiceRequestRepo {
  Map<String, String> get header {
    final sessionId = preferences.getString(SharedPreference.sessionId);

    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      if (sessionId != null && sessionId.isNotEmpty) 'Cookie': sessionId,
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
}
