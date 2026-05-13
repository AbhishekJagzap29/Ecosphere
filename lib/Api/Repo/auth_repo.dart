
import 'dart:developer';

import 'package:echosphere/Api/ResponseModel/login_response_model.dart';
import 'package:echosphere/Api/Services/api_services.dart';
import 'package:echosphere/Api/Services/base_service.dart';
import 'package:echosphere/View/Constant/shared_prefs.dart';

class AuthRepo {
  Map<String, String> header = {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  };

  Map<String, String> headerWithCookie = {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
    'Cookie':
        'Cookie_1=value; ${preferences.getString(SharedPreference.sessionId)}'
  };

  /// LOGIN REPO
  Future<dynamic> loginRepo({Map<String, dynamic>? body}) async {
    var response = await APIService().getResponse(
      url: ApiRouts.webSessionAuthenticateAPI,
      apiType: APIType.aPost,
      body: body,
      header: header,
    );

    log('loginResponse >>> $response');

    LoginResponseModel loginResponseModel =
        LoginResponseModel.fromJson(response);

    return loginResponseModel;
  }
}
