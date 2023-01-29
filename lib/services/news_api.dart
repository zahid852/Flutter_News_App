import 'dart:convert';
import 'dart:developer';

import 'package:news_app/consts/api_consts.dart';
import 'package:news_app/consts/http_exception.dart';
import 'package:news_app/models/bookmark_model.dart';
import 'package:news_app/models/news_model.dart';
import 'package:http/http.dart' as http;

class NewsApiServices {
  static Future<List<NewsModel>> getAllNews(
      {required int page, required String sortBy}) async {
    // var url = Uri.parse(
    //     'https://newsapi.org/v2/everything?q=bitcoin&pageSize=5&apiKey=5709ab9ba18541499f487ab7c23b2095');
    try {
      var uri = Uri.https(BaseUrl, 'v2/everything', {
        "q": "bitcoin", "pageSize": "6", "page": page.toString(),
        "sortBy": sortBy
        // "apiKey": api_key
      });
      var response = await http.get(uri, headers: {"X-Api-key": api_key});
      // log('Response body: ${response.body}');
      Map<String, dynamic> data = json.decode(response.body);

      if (data['code'] != null) {
        throw HttpException(data['code']).getNewsApiErrorMessage;
      }
      List newsTempList = [];
      for (var v in data['articles']) {
        newsTempList.add(v);
      }
      return NewsModel.newsFromSnapshot(newsTempList);
    } catch (error) {
      throw error.toString();
    }
  }

  static Future<List<NewsModel>> getTopHeadlines() async {
    // var url = Uri.parse(
    //     'https://newsapi.org/v2/everything?q=bitcoin&pageSize=5&apiKey=5709ab9ba18541499f487ab7c23b2095');
    try {
      var uri = Uri.https(BaseUrl, 'v2/top-headlines', {
        'country': 'us'
        // "q": "bitcoin", "pageSize": "6", "page": page.toString(),
        // "sortBy": sortBy
        // "apiKey": api_key
      });
      var response = await http.get(uri, headers: {"X-Api-key": api_key});
      // log('Response body: ${response.body}');
      Map<String, dynamic> data = json.decode(response.body);

      if (data['code'] != null) {
        throw HttpException(data['code']).getNewsApiErrorMessage;
      }
      List newsTempList = [];
      for (var v in data['articles']) {
        newsTempList.add(v);
      }
      return NewsModel.newsFromSnapshot(newsTempList);
    } catch (error) {
      throw error.toString();
    }
  }

  static Future<List<NewsModel>> searchNews({required String query}) async {
    // var url = Uri.parse(
    //     'https://newsapi.org/v2/everything?q=bitcoin&pageSize=5&apiKey=5709ab9ba18541499f487ab7c23b2095');
    try {
      var uri = Uri.https(BaseUrl, 'v2/everything', {
        "q": query, "pageSize": "10",
        // "apiKey": api_key
      });
      var response = await http.get(uri, headers: {"X-Api-key": api_key});
      // log('Response body: ${response.body}');
      Map<String, dynamic> data = json.decode(response.body);

      if (data['code'] != null) {
        throw HttpException(data['code']).getNewsApiErrorMessage;
      }
      List newsTempList = [];
      for (var v in data['articles']) {
        newsTempList.add(v);
      }
      return NewsModel.newsFromSnapshot(newsTempList);
    } catch (error) {
      throw error.toString();
    }
  }

  static Future<List<BookmarksModel>?> getBookmarks() async {
    try {
      var uri = Uri.https(
        firebase_baseUrl,
        'Bookmarks.json',
      );
      var response = await http.get(uri);
      log('Response body: ${response.body}');
      Map<String, dynamic> data = json.decode(response.body);

      if (data['code'] != null) {
        throw HttpException(data['code']).getNewsApiErrorMessage;
      }
      List<String> allKeys = [];
      for (String key in data.keys) {
        allKeys.add(key);
      }
      return BookmarksModel.bookmarksFromSnapshot(json: data, allKeys: allKeys);
    } catch (error) {
      rethrow;
    }
  }
}
