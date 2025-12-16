

import 'package:app_shortener/app/data/models/short_url_model.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/shortened_link_entity.dart';


class ShortenedLinkModel extends ShortenedLinkEntity with EquatableMixin {
  ShortenedLinkModel({required super.originalUrl, required super.shortUrl});

  factory ShortenedLinkModel.fromJson(Map<String, dynamic> json) {
    return ShortenedLinkModel(
      originalUrl: json['_links']['self'] as String,
      shortUrl: ShortUrlModel.fromJson(json),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      originalUrl: {'alias': shortUrl.alias, 'links': shortUrl},
    };
  }

  @override
  List<Object?> get props => [originalUrl, shortUrl];
}
