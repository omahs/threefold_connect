import 'package:flutter/material.dart';
import 'package:threebotlogin/core/auth/pin/views/auth.view.dart';
import 'package:threebotlogin/core/router/classes/router.classes.dart';
import 'package:threebotlogin/core/storage/globals.storage.dart';

Future<void> navigateIfAuthenticated(JRoute route) async {
  bool? isAuthenticated = await Navigator.push(Globals().globalBuildContext,
      MaterialPageRoute(builder: (context) => AuthenticationScreen(correctPin: '1111', userMessage: 'test')));

  if (isAuthenticated == true) {
    await Navigator.push(Globals().globalBuildContext, MaterialPageRoute(builder: (context) => route.view));
  }
}
