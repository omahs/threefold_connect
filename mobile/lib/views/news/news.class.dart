import 'package:flutter/material.dart';
import 'package:threebotlogin/app.dart';
import 'package:threebotlogin/core/events/classes/event.classes.dart';
import 'package:threebotlogin/core/events/services/events.service.dart';
import 'package:threebotlogin/views/news/news.view.dart';

class News implements App {
  static final News _singleton = new News._internal();
  static final NewsScreen _newsWidget = NewsScreen();

  factory News() {
    return _singleton;
  }

  News._internal();

  Future<Widget> widget() async {
    print('COMING INSIDE HERE');
    return _newsWidget;
  }

  void clearData() {}

  @override
  bool emailVerificationRequired() {
    print('test');
    return false;
  }

  @override
  bool pinRequired() {
    return false;
  }

  @override
  void back() {
    print('test');
    Events().emit(NewsGoBack());
  }
}
