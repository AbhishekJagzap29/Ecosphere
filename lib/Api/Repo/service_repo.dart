import 'dart:developer';

import 'package:echosphere/Api/ResponseModel/service_response_model.dart';
import 'package:echosphere/Api/Services/api_services.dart';
import 'package:echosphere/Api/Services/base_service.dart';
import 'package:echosphere/View/Constant/shared_prefs.dart';

class ServiceRepo {
  Map<String, String> get header {
    final sessionId = preferences.getString(SharedPreference.sessionId);

    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      if (sessionId != null && sessionId.isNotEmpty) 'Cookie': sessionId,
    };
  }

  /// SERVICE LIST REPO
  Future<ServiceResponseModel> serviceListRepo() async {
    final response = await APIService().getResponse(
      url: ApiRouts.servicesAPI,
      apiType: APIType.aGet,
      header: header,
    );

    log('serviceResponse >>> $response');

    return ServiceResponseModel.fromJson(response);
  }

  /// POPULAR SERVICE LIST REPO
  Future<ServiceResponseModel> popularServiceListRepo() async {
    final response = await APIService().getResponse(
      url: ApiRouts.popularServicesAPI,
      apiType: APIType.aGet,
      header: header,
    );

    log('popularServiceResponse >>> $response');

    return ServiceResponseModel.fromJson(response);
  }

  /// OTHER SERVICE LIST REPO
  Future<ServiceResponseModel> otherServiceListRepo() async {
    final response = await APIService().getResponse(
      url: ApiRouts.otherServicesAPI,
      apiType: APIType.aGet,
      header: header,
    );

    log('otherServiceResponse >>> $response');

    return ServiceResponseModel.fromJson(response);
  }
}
