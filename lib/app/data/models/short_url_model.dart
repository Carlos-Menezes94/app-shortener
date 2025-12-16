import 'package:equatable/equatable.dart';

import '../../domain/entities/short_url_entity.dart';

class ShortUrlModel extends ShortUrlEntity with EquatableMixin {
  ShortUrlModel({
    required super.alias,
    required super.self,
    required super.short,
  });

  factory ShortUrlModel.fromJson(Map<String, dynamic> json) {
    return ShortUrlModel(
      alias: json['alias'],
      self: json['_links']['self'],
      short: json['_links']['short'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'alias': alias,
      '_links': {'self': self, 'short': short},
    };
  }

  @override
  List<Object?> get props => [alias, self, short];
}
