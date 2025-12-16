
import 'package:app_shortener/app/data/models/shortened_link_model.dart';
import 'package:app_shortener/app/presentation/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ShortenedLinksListWidget extends StatelessWidget {
  final HomeController controller;
  
  const ShortenedLinksListWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<ShortenedLinkModel>>(
      valueListenable: controller.store.links,
      builder: (context, links, _) {
        if (links.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.link_off, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'Nenhum link encurtado ainda',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: links.length,
          itemBuilder: (context, index) {
            final link = links[index];

            return Dismissible(
              onDismissed: (_) {
                controller.deleteLinkAt(index);
              },
              key: ValueKey(link.shortUrl.alias),
              direction: DismissDirection.endToStart,
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20),
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              child: ListTile(
                title: Text(
                  link.shortUrl.short,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                ),
                subtitle: Text(
                  link.originalUrl,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.copy),
                  onPressed: () {
                    Clipboard.setData(
                      ClipboardData(text: link.shortUrl.short),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Link copiado!')),
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}