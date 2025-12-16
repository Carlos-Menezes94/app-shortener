
import 'package:app_shortener/app/data/datasources/short_url_datasource.dart';
import 'package:app_shortener/app/data/models/short_url_model.dart';

class ShortenUrlUseCase {
  final UrlShortenerDatasource repository;

  ShortenUrlUseCase(this.repository);

  Future<ShortUrlModel> call(String url) {
    return repository.shorten(url);
  }
}
