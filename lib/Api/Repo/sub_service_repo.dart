import 'dart:developer';

import 'package:echosphere/Api/ResponseModel/sub_service_response_model.dart';
import 'package:echosphere/Api/Services/api_services.dart';
import 'package:echosphere/Api/Services/base_service.dart';
import 'package:echosphere/View/Constant/shared_prefs.dart';

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
  }) async {
    final url = Uri.parse(ApiRouts.subServicesAPI).replace(
      queryParameters: {
        if (serviceId != null) 'service_id': serviceId.toString(),
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
