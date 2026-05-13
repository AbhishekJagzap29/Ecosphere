import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:http/http.dart' as http;

import '../../View/Constant/shared_prefs.dart';
import '../../View/Utils/app_layout.dart';
import '../Apis/app_exception.dart';

enum APIType { aPost, aGet, aPut, aDelete, aFileUpload }

enum HeaderType {
  hAppJson,
  hUrlencoded,
}

class APIService {
  dynamic response;

  Future<dynamic> getResponse({
    required String url,
    required APIType apiType,
    Map<String, dynamic>? body,
    Map<String, String>? header,
  }) async {
    log("url ===-----URL-----===>>>>> $url");
    log("headers ===-----HEADERS-----===>>>>> $header");

    try {
      if (apiType == APIType.aGet) {
        final result = await http.get(Uri.parse(url), headers: header);
        response = returnResponse(result.statusCode, result.body);
        log("res${result.body}");
      } else if (apiType == APIType.aPut) {
        log("REQUEST PARAMETER ======>>>>> ${jsonEncode(body)}");

        final result = await http.put(
          Uri.parse(url),
          headers: header,
          body: body,
        );
        log("resp${result.body}");

        response = returnResponse(result.statusCode, result.body);
        log('result.statusCode===>${result.statusCode}');
      } else if (apiType == APIType.aDelete) {
        final result = await http.delete(Uri.parse(url), headers: header);
        response = returnResponse(result.statusCode, result.body);
        log("res${result.body}");
      } else if (apiType == APIType.aFileUpload) {
        final data = dio.FormData.fromMap(body ?? {});

        final dioClient = dio.Dio();
        final result = await dioClient.post(
          url,
          options: dio.Options(headers: header),
          data: data,
        );
        log('result.statusCode---------->>>>>> ${result.statusCode}');

        response = returnResponse(result.statusCode!, jsonEncode(result.data));
      } else {
        log("REQUEST PARAMETER ======>>>>> ${json.encode(body)}");

        final result = await http.post(
          Uri.parse(url),
          body: jsonEncode(body),
          headers: header,
        );

        log("resp>>>>>result.statusCode>>>>>>${result.statusCode}");
        log("resp>>>>>result.body>>>>>>${result.body}");

        if (url.contains('/api/login') ||
            url.contains('/web/session/authenticate')) {
          if (result.statusCode == 403) {
            errorSnackBar(
              "Login Failed",
              "Please enter correct username and password",
            );
          }

          log("resp>>>>>result.headers>>>>>>${result.headers}");
          final setCookie = result.headers['set-cookie'];
          if (setCookie != null && setCookie.isNotEmpty) {
            final token = setCookie.split(";").first;
            await preferences.putString(SharedPreference.sessionId, token);
            await Future.delayed(const Duration(milliseconds: 500));
          }
        }

        response = returnResponse(result.statusCode, result.body);
      }
    } on SocketException {
      throw FetchDataException('No Internet access');
    }

    return response;
  }

  dynamic returnResponse(int status, String result) {
    final isJsonResponse =
        result.trimLeft().startsWith('{') || result.trimLeft().startsWith('[');

    switch (status) {
      case 200:
      case 201:
        if (!isJsonResponse) {
          if (_isLoginPage(result)) {
            throw UnauthorisedException(
              'Session expired. Please login again.',
            );
          }
          throw FetchDataException(result);
        }
        return jsonDecode(result);
      case 204:
        return {
          "status": "SUCCESS",
          "message": "SuccessFully Query List Get",
          "data": [],
        };
      case 400:
      case 401:
        if (isJsonResponse) {
          return jsonDecode(result);
        }
        throw BadRequestException(result);
      case 403:
        if (isJsonResponse) {
          return jsonDecode(result);
        }
        throw UnauthorisedException(result);
      case 404:
        if (isJsonResponse) {
          return jsonDecode(result);
        }
        throw ServerException(result);
      case 500:
        if (isJsonResponse) {
          return jsonDecode(result);
        }
        throw FetchDataException(result);
      default:
        if (isJsonResponse) {
          return jsonDecode(result);
        }
        throw FetchDataException('Internal Server Error');
    }
  }

  bool _isLoginPage(String result) {
    final value = result.toLowerCase();
    return value.contains('oe_login_form') ||
        value.contains('/web/login') ||
        value.contains('__session_info__') && value.contains('is_public');
  }
}
