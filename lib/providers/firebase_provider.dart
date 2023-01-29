import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:news_app/consts/api_consts.dart';
import 'package:news_app/models/bookmark_model.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/models/news_model.dart';
import 'package:news_app/services/news_api.dart';

class firebaseProvider with ChangeNotifier {
  List<BookmarksModel> bookMarksModelList = [];
  List<BookmarksModel> get getBookmarkList => bookMarksModelList;
  Future<void> addToBookmark({required NewsModel newsModel}) async {
    try {
      var uri = Uri.https(
        firebase_baseUrl,
        'Bookmarks.json',
      );
      var response = await http.post(uri, body: jsonEncode(newsModel.toJson()));
      notifyListeners();
      log('Response status: ${response.statusCode}');
      log('Response body: ${response.body}');
    } catch (error) {
      rethrow;
    }
  }

  Future<List<BookmarksModel>> fetchBookmarks() async {
    bookMarksModelList = await NewsApiServices.getBookmarks() ?? [];

    notifyListeners();
    return bookMarksModelList;
  }

  Future<void> deleteBookmark({required String key}) async {
    try {
      var uri = Uri.https(
        firebase_baseUrl,
        'Bookmarks/$key.json',
      );
      var response = await http.delete(uri);
      notifyListeners();
      log('Response status: ${response.statusCode}');
      log('Response body: ${response.body}');
    } catch (error) {
      rethrow;
    }
  }
}
