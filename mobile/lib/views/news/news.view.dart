import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:threebotlogin/core/router/tabs/views/tabs.core.dart';
import 'package:threebotlogin/core/events/classes/event.classes.dart';
import 'package:threebotlogin/core/events/services/events.service.dart';
import 'package:threebotlogin/core/storage/globals.storage.dart';
import 'package:threebotlogin/views/home/home.view.dart';
import 'package:threebotlogin/views/news/news.options.dart';

class NewsScreen extends StatefulWidget {
  NewsScreen();

  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  late InAppWebViewController webView;
  late InAppWebView iaWebView;


  _NewsScreenState() {
    iaWebView = InAppWebView(
      initialUrlRequest: request,
      initialOptions: options,
      onWebViewCreated: (InAppWebViewController controller) {
        webView = controller;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutDrawer(
        titleText: 'News',
        content: SafeArea(
            child: WillPopScope(
                child: iaWebView,
                onWillPop: () async {
                  await Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                  return Future.value(false);
                })));
  }
}
