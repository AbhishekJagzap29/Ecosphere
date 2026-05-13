import 'dart:developer';

import 'package:echosphere/Api/ResponseModel/customer_registration_response_model.dart';
import 'package:echosphere/Api/Services/api_services.dart';
import 'package:echosphere/Api/Services/base_service.dart';

class CustomerRegistrationRepo {
  Map<String, String> get header {
    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
  }

  Future<CustomerRegistrationResponseModel> registerCustomer({
    required String name,
    required String phone,
    required int talukaId,
    required bool isCardHolder,
  }) async {
    final response = await APIService().getResponse(
      url: ApiRouts.registerCustomerAPI,
      apiType: APIType.aPost,
      header: header,
      body: {
        'name': name,
        'phone': phone,
        'taluka_id': talukaId,
        'is_card_holder': isCardHolder,
      },
    );

    log('customerRegistrationResponse >>> $response');

    return CustomerRegistrationResponseModel.fromJson(response);
  }
}