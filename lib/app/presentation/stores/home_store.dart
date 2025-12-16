import 'package:app_shortener/app/data/models/shortened_link_model.dart';
import 'package:flutter/material.dart';

class HomeStore {
  final isLoading = ValueNotifier<bool>(false);
  final links = ValueNotifier<List<ShortenedLinkModel>>([]);
}