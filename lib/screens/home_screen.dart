import 'package:flutter/material.dart';
import 'package:news_app/services/news_api_services.dart';
import 'package:news_app/widgets/article_title.dart';

import '../models/news_model.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final NewsApiService _apiService = NewsApiService();
  late Future<List<Article>> _articles;

  @override
  void initState() {
    super.initState();
    _articles = _apiService.fetchTopHeadlines();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Top Headlines')),
      body: FutureBuilder<List<Article>>(
        future: _articles,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No articles found'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return ArticleTile(article: snapshot.data![index]);
            },
          );
        },
      ),
    );
  }
}
