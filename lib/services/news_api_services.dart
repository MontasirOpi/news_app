import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/news_model.dart';

class NewsApiService {
  final String _apiKey = '926effbb65a243d29c6da25e30a6ad36'; // Replace with your key
  final String _baseUrl = 'https://newsapi.org/v2';

  Future<List<Article>> fetchTopHeadlines() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/top-headlines?country=us&apiKey=$_apiKey'),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final newsResponse = NewsResponse.fromJson(jsonData);
      return newsResponse.articles;
    } else {
      throw Exception('Failed to load news');
    }
  }
}
