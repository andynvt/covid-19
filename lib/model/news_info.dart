import 'package:intl/intl.dart';

class NewsInfo {
  String title;
  String image;
  DateTime time;
  String url;

  NewsInfo({this.title, this.image, this.time, this.url});

  factory NewsInfo.fromJson(Map<String, dynamic> json) {
    final format = DateFormat('dd MMMM yyyy HH:mm');
    final DateTime time = format.parse(json['time']);

    return NewsInfo(
      title: json['title'],
      image: json['image'],
      time: time,
      url: json['url'],
    );
  }
}
