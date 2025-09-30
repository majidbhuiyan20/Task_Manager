import 'dart:convert';

import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class ApiCallerTest {
  static final Logger _logger = Logger();
  static Future<ApiResponseTest> getRequest({required String url}) async {
    try {
      Uri uri = Uri.parse(url);
      _loadRequest(url);
      Response response = await get(uri);
      _loadResponse(url, response);
      final int statusCode = response.statusCode;
      if(statusCode==200){
        final decodedData = json.decode(response.body);
        return ApiResponseTest(isSuccess: true, statusCode: statusCode, responseData: decodedData);

      }
      else{
        final decodedData = json.decode(response.body);
        return ApiResponseTest(isSuccess: false, statusCode: statusCode, responseData: decodedData);
      }
    } on Exception catch (e) {
      return ApiResponseTest(isSuccess: false, statusCode: -1, responseData: null, errorMessage: e.toString());
    }
  }

  static Future<ApiResponseTest> postRequest({required String url, Map<String, dynamic>? body}) async {
    try {
      Uri uri = Uri.parse(url);
      _loadRequest(url, body:body);
      Response response = await post(uri);
      _loadResponse(url, response);
      final int statusCode = response.statusCode;
      if(statusCode==200 || statusCode == 201){
        final decodedData = json.decode(response.body);
        return ApiResponseTest(isSuccess: true, statusCode: statusCode, responseData: decodedData);

      }
      else{
        final decodedData = json.decode(response.body);
        return ApiResponseTest(isSuccess: false, statusCode: statusCode, responseData: decodedData);
      }
    } on Exception catch (e) {
      return ApiResponseTest(isSuccess: false, statusCode: -1, responseData: null, errorMessage: e.toString());
    }
  }


  static void _loadRequest(String url, {Map<String, dynamic>? body}){
    _logger.i('URL => $url');
  }
  static void _loadResponse(String url, Response response){
    _logger.i('URL => $url\n'
        'Response => ${response.statusCode}\n'
        'Body => ${response.body}');
  }
}

class ApiResponseTest {
  final bool isSuccess;
  final int statusCode;
  final dynamic responseData;
  final String? errorMessage;

  ApiResponseTest({
    required this.isSuccess,
    required this.statusCode,
    required this.responseData,
    this.errorMessage,
  });
}
