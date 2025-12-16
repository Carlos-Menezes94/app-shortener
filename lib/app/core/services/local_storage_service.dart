import 'dart:convert';
import 'package:app_shortener/app/data/models/shortened_link_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageServiceImpl implements ILocalStorageService {
  late final SharedPreferencesAsync sharedPreferences;

  LocalStorageServiceImpl() {
    sharedPreferences = SharedPreferencesAsync();
  }

  static const _linksKey = 'shortened_links';

  @override
  Future<List<ShortenedLinkModel>> getLinks() async {
    final List<String>? linksJson = await sharedPreferences.getStringList(
      _linksKey,
    );

    if (linksJson == null) return [];

    return linksJson
        .map(
          (jsonString) => ShortenedLinkModel.fromJson(jsonDecode(jsonString)),
        )
        .toList();
  }

  @override
  Future<void> saveLinks(List<ShortenedLinkModel> links) async {
    final linksJson = links.map((link) => jsonEncode(link.toJson())).toList();

    await sharedPreferences.setStringList(_linksKey, linksJson);
  }
}

abstract class ILocalStorageService {
  Future<List<ShortenedLinkModel>> getLinks();
  Future<void> saveLinks(List<ShortenedLinkModel> links);
}
