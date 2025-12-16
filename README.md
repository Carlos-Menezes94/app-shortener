# App Shortener

Este é um aplicativo móvel desenvolvido em Flutter que tem como principal funcionalidade o encurtamento de URLs.

O aplicativo utiliza uma API de encurtamento para transformar links longos e complexos em URLs curtas e fáceis de compartilhar.

## Arquitetura

O projeto segue os princípios da **Clean Architecture**, dividindo as responsabilidades em três camadas principais:

- **Domain:** Contém a lógica de negócios pura, incluindo entidades (`ShortUrlEntity`) e casos de uso (`ShortenUrlUseCase`). Esta camada é independente de qualquer framework de UI ou fonte de dados.
- **Data:** Responsável pela obtenção de dados de fontes externas (API, banco de dados local). Inclui os repositórios e fontes de dados (`ShortUrlDatasource`).
- **Presentation:** Camada responsável pela interface do usuário (UI). Utiliza o padrão de `controller` para gerenciar o estado da tela, se comunicando com a camada de `domain` através de casos de uso.

## Gerenciamento de Estado

O gerenciamento de estado é feito de forma reativa e simples, utilizando `ValueNotifier` e `ValueListenableBuilder`.

- **`HomeStore`**: Atua como o "armazém" do estado da tela principal, contendo os `ValueNotifier` que representam as variáveis reativas (como a lista de links e o status de carregamento).
- **`HomeController`**: Orquestra as ações do usuário, executa os casos de uso e atualiza o `HomeStore`.
- **Widgets da UI**: Widgets como `HomePage` e `ShortenedLinksListWidget` utilizam `ValueListenableBuilder` para "escutar" as mudanças nos `ValueNotifier` do `HomeStore` e reconstruir a UI de forma eficiente quando o estado muda.

## Tecnologias e Bibliotecas

- **[Flutter](https://flutter.dev/)**: Framework principal para o desenvolvimento da interface.
- **[Flutter Modular](https://pub.dev/packages/flutter_modular)**: Para injeção de dependência e gerenciamento de rotas.
- **[Dio](https://pub.dev/packages/dio)**: Cliente HTTP para realizar as chamadas para a API de encurtamento de URL.
- **[Shared Preferences](https://pub.dev/packages/shared_preferences)**: Para armazenamento local dos links encurtados.
- **[Equatable](https://pub.dev/packages/equatable)**: Para facilitar a comparação de objetos.
- **[Mocktail](https://pub.dev/packages/mocktail)**: Para a criação de mocks nos testes.

## Testes

O projeto conta com testes de unidade e de widget para garantir a qualidade e o correto funcionamento da aplicação.

- **Testes de Unidade:** Verificam a lógica dos `controllers` e `usecases` de forma isolada. Os testes do `HomeController` (`test/home_controller_test.dart`) garantem que o estado é gerenciado corretamente ao carregar, adicionar e remover links.
- **Testes de Widget:** Verificam a renderização e interação dos componentes da UI. Os testes da `HomePage` (`test/home_page_test.dart`) garantem que a UI reage corretamente às diferentes situações, como lista vazia, adição de links e erros de validação.

### Como rodar os testes

Para executar todos os testes, utilize o seguinte comando no terminal:

```bash
flutter test
```

## Integração Contínua (CI)

O projeto utiliza GitHub Actions para automação da integração contínua, garantindo a qualidade e a estabilidade do código. O workflow está definido no arquivo `.github/workflows/ci.yml`.

O pipeline é acionado a cada `push` ou `pull request` para a branch `main` e executa os seguintes passos:

1.  **Checkout:** Clona o repositório.
2.  **Setup Flutter:** Configura o ambiente Flutter na versão estável.
3.  **Get Dependencies:** Baixa todas as dependências do projeto com `flutter pub get`.
4.  **Analyze:** Executa o analisador estático do Dart com `flutter analyze` para detectar possíveis erros e problemas de estilo.
5.  **Run Tests:** Roda a suíte de testes de unidade e de widget com `flutter test`.
6.  **Build APK:** Compila uma versão de depuração do aplicativo Android (`.apk`) para garantir que o projeto está "buildando" corretamente.

