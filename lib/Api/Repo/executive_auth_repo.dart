import 'dart:developer';

import 'package:dw_echosphere_app/Api/ResponseModel/executive_login_response_model.dart';
import 'package:dw_echosphere_app/Api/Services/api_services.dart';
import 'package:dw_echosphere_app/Api/Services/base_service.dart';

class ExecutiveAuthRepo {
  final Map<String, String> header = {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  };

  Future<ExecutiveLoginResponseModel> login({
    required String login,
    required String password,
  }) async {
    final response = await APIService().getResponse(
      url: ApiRouts.webSessionAuthenticateAPI,
      apiType: APIType.aPost,
      body: {
        'jsonrpc': '2.0',
        'params': {
          'db': ApiRouts.databaseName,
          'login': login,
          'password': password,
        },
      },
      header: header,
    );

    log('Executive Login Response >>> $response');

    return ExecutiveLoginResponseModel.fromJson(response);
  }
}
