import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:threebotlogin/core/components/tabs/tabs.core.dart';
import 'package:threebotlogin/core/events/classes/event.classes.dart';
import 'package:threebotlogin/core/events/services/events.service.dart';
import 'package:threebotlogin/views/news/news.options.dart';

class NewsScreen extends StatefulWidget {
  NewsScreen();

  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  late InAppWebViewController webView;
  late InAppWebView iaWebView;

  _back(NewsGoBack event) async {
    print("HALLO");
    Uri? url = await webView.getUrl();
    print("URL: " + url.toString());
    this.webView.goBack();
  }

  _NewsScreenState() {
    iaWebView = InAppWebView(
      initialUrlRequest: request,
      initialOptions: options,
      onWebViewCreated: (InAppWebViewController controller) {
        webView = controller;
      },
    );

    Events().onEvent(NewsGoBack().runtimeType, _back);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutDrawer(titleText: 'News', content: SafeArea(child: iaWebView));
  }
}
