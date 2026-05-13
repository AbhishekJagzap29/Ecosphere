import 'dart:developer';

import 'package:echosphere/Api/ResponseModel/service_detail_response_model.dart';
import 'package:echosphere/Api/Services/api_services.dart';
import 'package:echosphere/Api/Services/base_service.dart';
import 'package:echosphere/View/Constant/shared_prefs.dart';

class ServiceDetailRepo {
  Map<String, String> get header {
    final sessionId = preferences.getString(SharedPreference.sessionId);

    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      if (sessionId != null && sessionId.isNotEmpty) 'Cookie': sessionId,
    };
  }

  /// SERVICE DETAIL LIST REPO
  Future<ServiceDetailResponseModel> serviceDetailListRepo({
    int? subserviceId,
  }) async {
    final url = Uri.parse(ApiRouts.serviceDetailsAPI).replace(
      queryParameters: {
        if (subserviceId != null) 'subservice_id': subserviceId.toString(),
      },
    ).toString();

    final response = await APIService().getResponse(
      url: url,
      apiType: APIType.aGet,
      header: header,
    );

    log('serviceDetailResponse >>> $response');

    return ServiceDetailResponseModel.fromJson(response);
  }
}
