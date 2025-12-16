import 'package:app_shortener/app/core/services/local_storage_service.dart';
import 'package:app_shortener/app/data/models/short_url_model.dart';
import 'package:app_shortener/app/data/models/shortened_link_model.dart';
import 'package:app_shortener/app/domain/usecases/short_url_usecase.dart';
import 'package:app_shortener/app/presentation/controllers/home_controller.dart';
import 'package:app_shortener/app/presentation/pages/home_page.dart';
import 'package:app_shortener/app/presentation/stores/home_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockILocalStorageService extends Mock implements ILocalStorageService {}

class MockShortenUrlUseCase extends Mock implements ShortenUrlUseCase {}

void main() {
  late HomeStore store;
  late MockILocalStorageService localStorageService;
  late MockShortenUrlUseCase shortenUrlUseCase;
  late HomeController controller;

  setUpAll(() {
    registerFallbackValue(<ShortenedLinkModel>[]);
  });

  setUp(() {
    store = HomeStore();
    localStorageService = MockILocalStorageService();
    shortenUrlUseCase = MockShortenUrlUseCase();
    controller = HomeController(store, localStorageService, shortenUrlUseCase);

    // Configuração básica para evitar erros na inicialização
    when(() => localStorageService.getLinks()).thenAnswer((_) async => []);
  });

  Widget makeTestableWidget() {
    return MaterialApp(home: HomePage(controller: controller));
  }

  group('[WIDGET TEST] HomePage  ->', () {
    testWidgets(
      'Should show empty state icon and message when link list is empty',
      (tester) async {
        // O Arrange está no setUp, garantindo que getLinks() retorna []

        await tester.pumpWidget(makeTestableWidget());
        // Aciona o Future do loadLinks()
        await tester.pump();

        expect(find.byIcon(Icons.link_off), findsOneWidget);
        expect(find.text('Nenhum link encurtado ainda'), findsOneWidget);

        verify(() => localStorageService.getLinks()).called(1);
      },
    );

    testWidgets('Should show validation error when submitting an empty URL', (
      tester,
    ) async {
      await tester.pumpWidget(makeTestableWidget());
      await tester.pump();

      await tester.tap(find.byIcon(Icons.arrow_forward));
      // Aciona a reconstrução para mostrar a validação
      await tester.pump();

      expect(find.text('Informe uma URL'), findsOneWidget);
    });

    testWidgets('Should display list of links when at least one link exists', (
      tester,
    ) async {
      final fakeLink = ShortenedLinkModel(
        originalUrl: 'https://www.youtube.com.br',
        shortUrl: ShortUrlModel(
          alias: 'abc123',
          short: 'https://short.ly/abc123',
          self: 'https://short.ly/abc1232323',
        ),
      );

      when(
        () => localStorageService.getLinks(),
      ).thenAnswer((_) async => [fakeLink]);

      await tester.pumpWidget(makeTestableWidget());
      // Recarrega os links
      await tester.pump();
      expect(find.byType(ListTile), findsOneWidget);
      expect(find.text('https://short.ly/abc123'), findsOneWidget);
      expect(find.text('https://www.youtube.com.br'), findsOneWidget);

      expect(find.byIcon(Icons.link_off), findsNothing);
      expect(find.text('Nenhum link encurtado ainda'), findsNothing);
    });
  });
}
