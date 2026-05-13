import 'dart:developer';

import 'package:echosphere/Api/ResponseModel/taluka_response_model.dart';
import 'package:echosphere/Api/Services/api_services.dart';
import 'package:echosphere/Api/Services/base_service.dart';
import 'package:echosphere/View/Constant/shared_prefs.dart';

class TalukaRepo {
  Map<String, String> get header {
    final sessionId = preferences.getString(SharedPreference.sessionId);

    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      if (sessionId != null && sessionId.isNotEmpty) 'Cookie': sessionId,
    };
  }

  Future<TalukaResponseModel> talukaListRepo() async {
    final response = await APIService().getResponse(
      url: ApiRouts.talukasAPI,
      apiType: APIType.aGet,
      header: header,
    );

    log('talukaResponse >>> $response');

    return TalukaResponseModel.fromJson(response);
  }
}