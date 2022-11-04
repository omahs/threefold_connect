import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:threebotlogin/core/events/classes/event.classes.dart';
import 'package:threebotlogin/core/events/services/events.service.dart';
import 'package:threebotlogin/core/router/tabs/views/tabs.views.dart';
import 'package:threebotlogin/core/storage/globals.storage.dart';
import 'package:threebotlogin/views/farmer/options/farmer.options.dart';
import 'package:threebotlogin/views/wallet/configs/wallet.config.dart';


class FarmerScreen extends StatefulWidget {
  FarmerScreen();

  _FarmerScreenState createState() => _FarmerScreenState();
}

class _FarmerScreenState extends State<FarmerScreen> with AutomaticKeepAliveClientMixin {
  late InAppWebViewController webView;
  late InAppWebView iaWebView;

  WalletConfig config = WalletConfig();

  _FarmerScreenState() {
    iaWebView = InAppWebView(
      initialUrlRequest: requestFarmer,
      initialOptions: optionsFarmer,
      onConsoleMessage: (InAppWebViewController controller, ConsoleMessage consoleMessage) {
        print("Farmer console: " + consoleMessage.message);
      },
      onWebViewCreated: (InAppWebViewController controller) {
        webView = controller;
      },
    );

    Globals().isFarmerCacheCleared = true;
  }

  _back() async {
    Uri? url = await webView.getUrl();

    if (url.toString() == Globals().farmerUrl) {
      Events().emit(GoHomeEvent());
      return Future.value(true);
    }

    this.webView.goBack();
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return LayoutDrawer(
        titleText: 'Farming',
        content: WillPopScope(
          child: iaWebView,
          onWillPop: () => _back(),
        ));
  }

  @override
  bool get wantKeepAlive => false;
}
