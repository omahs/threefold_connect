import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:threebotlogin/core/storage/globals.storage.dart';

URLRequest request = URLRequest(
    url: Uri.parse(Globals().wizardUrl + '?cache_buster=' + new DateTime.now().millisecondsSinceEpoch.toString()));

InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
    android: AndroidInAppWebViewOptions(supportMultipleWindows: true, useHybridComposition: true));
