import 'package:intl/intl.dart';

class NewsInfo {
  String source;
  String author;
  String title;
  String description;
  String url;
  String urlToImage;
  DateTime publishedAt;
  String content;

  NewsInfo({this.source, this.author, this.title, this.description, this.url,
      this.urlToImage, this.publishedAt, this.content});

  factory NewsInfo.fromJson(Map<String, dynamic> json) {
    return NewsInfo(
      source: json['source']['name'],
      author: json['author'],
      title: json['title'],
      description: json['description'],
      url: json['url'],
      urlToImage: json['urlToImage'],
      publishedAt: DateTime.parse(json['publishedAt']),
      content: json['content'],
    );
  }
//  String title;
//  String image;
//  DateTime time;
//  String url;
//
//  NewsInfo({this.title, this.image, this.time, this.url});
//
//  factory NewsInfo.fromJson(Map<String, dynamic> json) {
//    final format = DateFormat('dd MMMM yyyy HH:mm');
//    final DateTime time = format.parse(json['time']);
//
//    return NewsInfo(
//      title: json['title'],
//      image: json['image'],
//      time: time,
//      url: json['url'],
//    );
//  }
}
