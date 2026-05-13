class ApiRouts {
  static const String databaseName = "ecosphere";

  /// BASE URL
  static String base = "http://143.110.185.14:8080";

  static String webSessionAuthenticateAPI = "$base/web/session/authenticate";

  /// AUTH API
  static String loginAPI = "$base/api/login";

  /// SERVICES API
  static String servicesAPI = "$base/api/services";
  static String popularServicesAPI = "$base/api/popular_services";
  static String otherServicesAPI = "$base/api/other_services";

  /// SUB SERVICES API
  static String subServicesAPI = "$base/api/subservices";

  /// SERVICE DETAILS API
  static String serviceDetailsAPI = "$base/api/service_details";

   /// CUSTOMER REGISTRATION API
  static String registerCustomerAPI = "$base/api/register_customer";
  /// TALUKAS API
  static String talukasAPI = "$base/api/talukas";

  /// SERVICE REQUEST API
  static String createServiceRequestAPI = "$base/api/create_service_request";
}
