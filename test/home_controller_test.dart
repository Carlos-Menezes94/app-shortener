
import 'package:app_shortener/app/core/services/local_storage_service.dart';
import 'package:app_shortener/app/data/models/short_url_model.dart';
import 'package:app_shortener/app/data/models/shortened_link_model.dart';
import 'package:app_shortener/app/domain/usecases/short_url_usecase.dart';
import 'package:app_shortener/app/presentation/controllers/home_controller.dart';
import 'package:app_shortener/app/presentation/stores/home_store.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockILocalStorageService extends Mock implements ILocalStorageService {}
class MockShortenUrlUseCase extends Mock implements ShortenUrlUseCase {}

void main() {
  late HomeController controller;
  late MockILocalStorageService mockLocalStorageService;
  late MockShortenUrlUseCase mockShortenUrlUseCase;
  late HomeStore store;

  setUp(() {
    registerFallbackValue([]);

    mockLocalStorageService = MockILocalStorageService();
    mockShortenUrlUseCase = MockShortenUrlUseCase();
    store = HomeStore();
    controller = HomeController(
      store,
      mockLocalStorageService,
      mockShortenUrlUseCase,
    );
  });

  group('[UNIT TEST] HomeController | loadLinks ->', () {
    final tLinks = [
      ShortenedLinkModel(originalUrl: 'url1', shortUrl: ShortUrlModel(alias: 'ali1', self: 'self1', short: 'short1')),
      ShortenedLinkModel(originalUrl: 'url2', shortUrl: ShortUrlModel(alias: 'ali2', self: 'self2', short: 'short2')),
    ];

    test('Should load links from local storage service and update store', () async {
      when(() => mockLocalStorageService.getLinks()).thenAnswer((_) async => tLinks);

      await controller.loadLinks();

      expect(store.links.value, equals(tLinks));
      expect(store.isLoading.value, isFalse);
      verify(() => mockLocalStorageService.getLinks()).called(1);
    });

    test('Should set isLoading to false if an error occurs during loading', () async {
      when(() => mockLocalStorageService.getLinks()).thenThrow(Exception());

      await controller.loadLinks();

      expect(store.isLoading.value, isFalse);
      verify(() => mockLocalStorageService.getLinks()).called(1);
    });
  });

  group('[UNIT TEST] HomeController | shortenUrl ->', () {
    const tOriginalUrl = 'https://google.com';

    final tShortUrlModel = ShortUrlModel(
      alias: 'google-alias',
      short: 'https://shrt.co/google-alias',
      self: tOriginalUrl,
    );

    final tNewShortenedLink = ShortenedLinkModel(
      originalUrl: tOriginalUrl,
      shortUrl: tShortUrlModel,
    );

    final tInitialLinks = [
      ShortenedLinkModel(originalUrl: 'old', shortUrl: ShortUrlModel(alias: 'old-alias', short: 'old-short', self: 'old')),
    ];

    setUp(() {
      store.links.value = tInitialLinks;
    });

    test('Should call usecase, add new link to list, and save to storage on success', () async {
      when(() => mockShortenUrlUseCase(tOriginalUrl)).thenAnswer((_) async => tShortUrlModel);
      when(() => mockLocalStorageService.saveLinks(any())).thenAnswer((_) async => true);

      final result = await controller.shortenUrl(tOriginalUrl);

      final expectedLinks = [tNewShortenedLink, ...tInitialLinks];

      expect(result, isTrue);
      expect(store.isLoading.value, isFalse);
      expect(store.links.value, equals(expectedLinks));

      verify(() => mockShortenUrlUseCase(tOriginalUrl)).called(1);
      verify(() => mockLocalStorageService.saveLinks(expectedLinks)).called(1);
    });

    test('Should return false and not update store on usecase failure', () async {
      when(() => mockShortenUrlUseCase(tOriginalUrl)).thenThrow(Exception('API Failure'));
      when(() => mockLocalStorageService.saveLinks(any())).thenAnswer((_) async => true);

      final result = await controller.shortenUrl(tOriginalUrl);

      expect(result, isFalse);
      expect(store.isLoading.value, isFalse);
      expect(store.links.value, equals(tInitialLinks));

      verify(() => mockShortenUrlUseCase(tOriginalUrl)).called(1);
      verifyNever(() => mockLocalStorageService.saveLinks(any()));
    });
  });

  group('[UNIT TEST] HomeController | deleteLinkAt ->', () {
    final tLinks = [
      ShortenedLinkModel(originalUrl: 'url0', shortUrl: ShortUrlModel(alias: 'ali0', short: 'short0', self: 'self0')),
      ShortenedLinkModel(originalUrl: 'url1', shortUrl: ShortUrlModel(alias: 'ali1', short: 'short1', self: 'self1')),
    ];

    setUp(() {
      store.links.value = tLinks;
    });

    test('Should remove link at specified index, save to storage, and return removed item', () async {
      const indexToDelete = 0;
      final expectedRemovedItem = tLinks[indexToDelete];
      final expectedLinksAfterDeletion = [tLinks[1]];
      when(() => mockLocalStorageService.saveLinks(any())).thenAnswer((_) async => true);

      final removedItem = await controller.deleteLinkAt(indexToDelete);

      expect(removedItem, equals(expectedRemovedItem));
      expect(store.links.value, equals(expectedLinksAfterDeletion));

      verify(() => mockLocalStorageService.saveLinks(expectedLinksAfterDeletion)).called(1);
    });
  });
}