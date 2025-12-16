
import 'package:app_shortener/app/presentation/controllers/home_controller.dart';
import 'package:app_shortener/app/presentation/widgets/shortened_links_list_widget.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final HomeController controller;
  const HomePage({super.key, required this.controller});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _urlController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _urlRegex = RegExp(
    r'^(https?:\/\/)?'
    r'([\da-z\.-]+)\.([a-z\.]{2,6})'
    r'([\/\w \.-]*)*\/?$',
  );

  @override
  void initState() {
    super.initState();
    // Carrega os links salvos ao iniciar a tela
    widget.controller.loadLinks();
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  // Método responsável por chamar a lógica de negócio e tratar a resposta da UI
  Future<void> _handleShortenUrl() async {
    // 1. Valida o formulário
    if (!_formKey.currentState!.validate()) return;

    // 2. Chama a lógica do Controller
    final success = await widget.controller.shortenUrl(_urlController.text);

    // 3. Trata a resposta (UI)
    if (success) {
      _urlController.clear();
    } else {
      // Exibe SnackBar de falha
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Ocorreu um erro em nossos servidores. Tente novamente mais tarde.',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Encurtador de URL'),
        backgroundColor: Colors.purple,
        centerTitle: true,
      ),
      // Removemos o Padding do corpo (body) para aplicar o Divider de ponta a ponta
      body: Column(
        children: [
          // 1. Área do Formulário (Com Padding de 16 nas laterais e topo/fundo)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _urlController,
                      keyboardType: TextInputType.url,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: const InputDecoration(
                        hintText: 'https://',
                        filled: true,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Informe uma URL';
                        }
                        if (!_urlRegex.hasMatch(value.trim())) {
                          return 'Informe uma URL válida';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  ValueListenableBuilder<bool>(
                    valueListenable: widget.controller.store.isLoading,
                    builder: (context, isLoading, _) {
                      return SizedBox(
                        height: 50,
                        width: 50,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : _handleShortenUrl,
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            backgroundColor: Colors.grey.shade300,
                            padding: EdgeInsets.zero,
                            elevation: 0,
                          ),
                          child:
                              isLoading
                                  ? const SizedBox(
                                    height: 18,
                                    width: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.black,
                                    ),
                                  )
                                  : const Icon(
                                    Icons.arrow_forward,
                                    color: Colors.black,
                                  ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          Divider(height: 20, color: Colors.grey.shade400),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ShortenedLinksListWidget(controller: widget.controller),
            ),
          ),
        ],
      ),
    );
  }
}
