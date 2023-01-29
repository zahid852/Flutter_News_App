import 'package:flutter/cupertino.dart';
import 'package:news_app/models/news_model.dart';
import 'package:news_app/services/news_api.dart';

class NewsProvider with ChangeNotifier {
  List<NewsModel> newsList = [];
  List<NewsModel> get NewsList {
    return newsList;
  }

  Future<List<NewsModel>> fetchAllNews(
      {required int page, required String sortBy}) async {
    newsList = await NewsApiServices.getAllNews(page: page, sortBy: sortBy);
    print('printing again');
    return newsList;
  }

  Future<List<NewsModel>> fetchTopHeadlines() async {
    newsList = await NewsApiServices.getTopHeadlines();
    print('printing again');
    return newsList;
  }

  Future<List<NewsModel>> fetchSearchNews({required String query}) async {
    newsList = await NewsApiServices.searchNews(query: query);
    print('printing again');
    return newsList;
  }

  NewsModel findById({required String? publishedAt}) {
    return newsList
        .firstWhere((NewsModel) => NewsModel.publishedAt == publishedAt);
  }
}
