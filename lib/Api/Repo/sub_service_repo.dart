import 'dart:developer';

import 'package:dw_echosphere_app/Api/ResponseModel/sub_service_response_model.dart';
import 'package:dw_echosphere_app/Api/Services/api_services.dart';
import 'package:dw_echosphere_app/Api/Services/base_service.dart';
import 'package:dw_echosphere_app/View/Constant/shared_prefs.dart';

class SubServiceRepo {
  Map<String, String> get header {
    final sessionId = preferences.getString(SharedPreference.sessionId);

    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      if (sessionId != null && sessionId.isNotEmpty) 'Cookie': sessionId,
    };
  }

  /// SUB SERVICE LIST REPO
  Future<SubServiceResponseModel> subServiceListRepo({
    int? serviceId,
    int? talukaId,
  }) async {
    final url = Uri.parse(ApiRouts.subServicesAPI).replace(
      queryParameters: {
        if (serviceId != null) 'service_id': serviceId.toString(),
        if (talukaId != null) 'taluka_id': talukaId.toString(),
      },
    ).toString();

    final response = await APIService().getResponse(
      url: url,
      apiType: APIType.aGet,
      header: header,
    );

    log('subServiceResponse >>> $response');

    return SubServiceResponseModel.fromJson(response);
  }
}
