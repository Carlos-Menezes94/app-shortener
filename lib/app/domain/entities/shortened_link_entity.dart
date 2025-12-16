import 'package:app_shortener/app/domain/entities/short_url_entity.dart';

class ShortenedLinkEntity {
  final String originalUrl;
  final ShortUrlEntity shortUrl;

  ShortenedLinkEntity({required this.originalUrl, required this.shortUrl});
}
