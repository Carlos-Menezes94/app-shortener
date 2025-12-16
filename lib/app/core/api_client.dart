import 'package:app_shortener/app/core/api_constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ApiClient {
  final Dio dio;

  ApiClient(this.dio) {
    dio.options.baseUrl = ApiConstants.baseUrl;
    dio.options.headers['Content-Type'] = 'application/json';

    if (kDebugMode) {
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            debugPrint('--> ${options.method.toUpperCase()} ${options.uri}');
            debugPrint('Headers: ${options.headers}');
            debugPrint('Body: ${options.data}');
            return handler.next(options);
          },
          onResponse: (response, handler) {
            debugPrint('<-- Status ${response.statusCode} ${response.requestOptions.uri}');
            return handler.next(response);
          },
          onError: (DioException e, handler) {
            debugPrint('Error: Status ${e.response?.statusCode} ${e.requestOptions.uri}');
            return handler.next(e);
          },
        ),
      );
    }
  }
}