import 'package:flutter/material.dart';

class JRoute {
  final IconData icon;
  final String name;
  final String path;
  final Widget view;
  final bool canSee;
  final bool? emailRequired;
  final bool? pinRequired;

  JRoute(
      {required this.path,
      required this.name,
      required this.icon,
      required this.view,
      required this.canSee,
      this.emailRequired,
      this.pinRequired});
}

class AppInfo {
  JRoute route;

  AppInfo({required this.route});
}
