
import 'dart:convert';

import 'package:app_shortener/app/core/api_client.dart';
import 'package:app_shortener/app/core/api_constants.dart';
import 'package:app_shortener/app/data/models/short_url_model.dart';
import 'package:dio/dio.dart';

class UrlShortenerDatasource {
  final ApiClient _apiClient;

  UrlShortenerDatasource(this._apiClient);

  Future<ShortUrlModel> shorten(String url) async {
    try {
      final response = await _apiClient.dio.post(
        ApiConstants.aliasEndpoint,
        data: jsonEncode({'url': url}),
      );
      return ShortUrlModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception("Erro ao encurtar URL: ${e.message}");
    }
  }
}
