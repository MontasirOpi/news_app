import 'package:flutter/material.dart';
import 'package:news_app/models/news_model.dart';
import 'package:url_launcher/url_launcher.dart';

class ArticleTile extends StatelessWidget {
  final Article article;

  const ArticleTile({super.key, required this.article});

  void _launchURL(BuildContext context, String url) async {
    if (url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Article URL is empty')),
      );
      return;
    }

    // Validate and ensure the URL has a proper scheme
    Uri? uri = Uri.tryParse(url);
    if (uri == null || !(uri.isScheme('http') || uri.isScheme('https'))) {
      uri = Uri.tryParse('https://$url');
    }

    if (uri == null || !(uri.isScheme('http') || uri.isScheme('https'))) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid article URL')),
      );
      return;
    }

    try {
      final bool launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!launched) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open the article')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error launching article: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (article.urlToImage != null)
            Image.network(
              article.urlToImage!,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              article.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(article.description ?? "No description available"),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => _launchURL(context, article.url),
              child: const Text('Read Full Article'),
            ),
          ),
        ],
      ),
    );
  }
}
