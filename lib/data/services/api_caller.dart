import 'dart:convert';

import 'package:http/http.dart';
import 'package:logger/logger.dart';

class ApiCaller {
  final Logger _logger = Logger();
  Future<ApiResponse> getRequest({required String url}) async {

    try {
      Uri uri = Uri.parse(url);
      _logRequest(url);
      Response response = await get(uri);

      _logResponse(url, response);

      print(url);
      print(response.statusCode);
      print(response.body);
      final int statusCode = response.statusCode;

      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body);
        return ApiResponse(
          isSuccess: true,
          responseCode: statusCode,
          responseData: decodedData,
        );
      } else {
        final decodedData = json.decode(response.body);
        return ApiResponse(
          isSuccess: false,
          responseCode: statusCode,
          responseData: decodedData,
        );
      }
    } on Exception catch (e) {
      return ApiResponse(
        isSuccess: false,
        responseCode: -1,
        responseData: null,
        errorMessage: e.toString(),
      );
    }
  }
  void _logRequest(String url){
    _logger.i('URL => $url');
  }
  void _logResponse(String url, Response response){
    _logger.i('URL => $url\n'
        'Status Code => ${response.statusCode}'
        'Body => ${response.body}');


  }
}

class ApiResponse {
  final bool isSuccess;
  final int responseCode;
  final dynamic responseData;
  final String? errorMessage;

  ApiResponse({
    required this.isSuccess,
    required this.responseCode,
    required this.responseData,
    this.errorMessage = "Something went wrong",
  });
}
