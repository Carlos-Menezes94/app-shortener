
import 'package:app_shortener/app/core/controller.dart';
import 'package:app_shortener/app/core/services/local_storage_service.dart';
import 'package:app_shortener/app/data/models/shortened_link_model.dart';
import 'package:app_shortener/app/domain/usecases/short_url_usecase.dart';
import 'package:app_shortener/app/presentation/stores/home_store.dart';

class HomeController extends Controller {
  final ILocalStorageService _localStorageService;
  final ShortenUrlUseCase _shortenUrlUseCase;
  final HomeStore store;

  HomeController(
    this.store,
    this._localStorageService,
    this._shortenUrlUseCase,
  );

  Future<void> loadLinks() async {
    try {
      store.isLoading.value = true;
      final loadedLinks = await _localStorageService.getLinks();
      store.links.value = loadedLinks;
    } catch (e) {
      store.isLoading.value = false;
    } finally {
      store.isLoading.value = false;
    }
  }

  Future<bool> shortenUrl(String url) async {
    store.isLoading.value = true;

    try {
      final result = await _shortenUrlUseCase(url);

      final newLinks = List<ShortenedLinkModel>.from(store.links.value);

      newLinks.insert(
        0,
        ShortenedLinkModel(originalUrl: url, shortUrl: result),
      );

      store.links.value = newLinks;
      await _localStorageService.saveLinks(store.links.value);

      return true;
    } catch (_) {
      return false;
    } finally {
      store.isLoading.value = false;
    }
  }

  Future<ShortenedLinkModel> deleteLinkAt(int index) async {
    final updatedLinks = List<ShortenedLinkModel>.from(store.links.value);
    final removedItem = updatedLinks.removeAt(index);

    store.links.value = updatedLinks;
    await _localStorageService.saveLinks(updatedLinks);

    return removedItem;
  }
}

