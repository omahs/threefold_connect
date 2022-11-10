import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:threebotlogin/core/storage/globals.storage.dart';

String cacheBusterSupport = new DateTime.now().millisecondsSinceEpoch.toString();

URLRequest requestSupport = URLRequest(url: Uri.parse(Globals().supportUrl + '?cache_buster=' + cacheBusterSupport));

InAppWebViewGroupOptions optionsSupport = InAppWebViewGroupOptions(
    crossPlatform: InAppWebViewOptions(useShouldOverrideUrlLoading: true),
    android: AndroidInAppWebViewOptions(supportMultipleWindows: true, useHybridComposition: true));
