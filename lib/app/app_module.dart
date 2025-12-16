
import 'package:app_shortener/app/core/api_client.dart';
import 'package:app_shortener/app/core/services/local_storage_service.dart';
import 'package:app_shortener/app/data/datasources/short_url_datasource.dart';
import 'package:app_shortener/app/domain/usecases/short_url_usecase.dart';
import 'package:app_shortener/app/presentation/controllers/home_controller.dart';
import 'package:app_shortener/app/presentation/pages/home_page.dart';
import 'package:app_shortener/app/presentation/stores/home_store.dart';
import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AppModule extends Module {
  @override
  void binds(Injector i) {
    i.addInstance<Dio>(Dio());
    i.add(HomeController.new);
    i.addLazySingleton<ILocalStorageService>(LocalStorageServiceImpl.new);
    i.add(ApiClient.new);
    i.add(UrlShortenerDatasource.new);
    i.add(ShortenUrlUseCase.new);
    i.add(HomeStore.new);
  }

  @override
  void routes(RouteManager r) {
    r.child(
      '/',
      child: (context) => HomePage(controller: Modular.get<HomeController>()),
    );
    super.routes(r);
  }
}
