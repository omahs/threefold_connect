import 'package:flutter/material.dart';
import 'package:threebotlogin/core/router/classes/router.classes.dart';
import 'package:threebotlogin/views/home.view.dart';

List<AppInfo> routes = [
  AppInfo(
      route: JRoute(
        path: '/',
        name: 'Home',
        icon: Icons.home,
        view: HomeScreen(),
      ),
      app: null),
];
