import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:news_app/services/global_methods.dart';
import 'package:reading_time/reading_time.dart';

class NewsModel with ChangeNotifier {
  String newsId,
      sourceName,
      authorName,
      title,
      description,
      url,
      urlToImage,
      publishedAt,
      content,
      dateToShow,
      readingTimeText;
  NewsModel(
      {required this.newsId,
      required this.sourceName,
      required this.authorName,
      required this.title,
      required this.description,
      required this.url,
      required this.urlToImage,
      required this.publishedAt,
      required this.content,
      required this.dateToShow,
      required this.readingTimeText});

  factory NewsModel.fromJson(dynamic json) {
    String title = json['title'] ?? '';
    String content = json['content'] ?? '';
    String description = json['description'] ?? '';
    String dateToShow = '';
    if (json['publishedAt'] != null) {
      dateToShow = GlobalMethods.formatedDateText(json['publishedAt']);
    }

    return NewsModel(
        newsId: json['source']['id'] ?? '',
        sourceName: json['source']['name'] ?? '',
        authorName: json['author'] ?? '',
        title: title,
        description: description,
        url: json['url'] ?? '',
        urlToImage: json['urlToImage'] ?? '',
        publishedAt: json['publishedAt'] ?? '',
        content: content,
        dateToShow: dateToShow,
        readingTimeText: readingTime(title + content + description).msg);
  }
  static List<NewsModel> newsFromSnapshot(List newsSnapshot) {
    return newsSnapshot
        .map((jsonItem) => NewsModel.fromJson(jsonItem))
        .toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['NewsId'] = newsId;
    data['sourceName'] = sourceName;
    data['authorName'] = authorName;
    data['title'] = title;
    data['description'] = description;
    data['url'] = url;
    data['urlToImage'] = urlToImage;
    data['publishedAt'] = publishedAt;
    data['content'] = content;
    data['dataToShow'] = dateToShow;
    data['readingTimeText'] = readingTimeText;
    return data;
  }
}
