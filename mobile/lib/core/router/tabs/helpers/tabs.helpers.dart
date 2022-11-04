import 'package:flutter/material.dart';
import 'package:threebotlogin/core/auth/pin/views/auth.view.dart';
import 'package:threebotlogin/core/router/classes/router.classes.dart';
import 'package:threebotlogin/core/storage/auth/auth.storage.dart';
import 'package:threebotlogin/core/storage/globals.storage.dart';
import 'package:threebotlogin/views/home/views/home.view.dart';

Future<void> navigateIfAuthenticated(JRoute route, BuildContext ctx) async {
  String? correctPin = await getPin();
  bool? isAuthenticated = await Navigator.push(
      ctx, MaterialPageRoute(builder: (context) => AuthenticationScreen(correctPin: correctPin!, userMessage: 'test')));

  print(isAuthenticated);
  if (isAuthenticated == true) {
    print('I WILL PUSH THE SCREEN');
    await Navigator.push(ctx, MaterialPageRoute(builder: (context) => route.view));
  }
}
