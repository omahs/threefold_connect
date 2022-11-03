import 'package:flutter/material.dart';
import 'package:threebotlogin/app.dart';
import 'package:threebotlogin/core/router/routes/router.routes.dart';

class JRoute {
  final IconData icon;
  final String name;
  final String path;
  final Widget view;
  final bool canSee;

  JRoute({required this.path, required this.name, required this.icon, required this.view, required this.canSee});
}

class AppInfo {
  JRoute route;
  App? app;

  AppInfo({required this.route, this.app});
}

class JRouter {
  Map<String, Widget Function(BuildContext)> getRoutes() {
    return Map.fromIterable(routes, key: (v) => v.path, value: (v) => v.view);
  }

  bool emailMustBeVerified(int index) {
    if (routes[index].app != null) {
      return routes[index].app!.emailVerificationRequired();
    }
    return false;
  }

  bool pinRequired(int index) {
    if (routes[index].app != null) {
      return routes[index].app!.pinRequired();
    }
    return false;
  }

  List<Widget> getContent() {
    List<Widget> containers = [];
    routes.forEach((r) {
      containers.add(r.route.view);
    });
    return containers;
  }

  List<Container> getAppButtons() {
    List<Container> iconButtons = [];
    routes.forEach((r) {
      iconButtons.add(Container(
          child: Tab(
        icon: Icon(
          r.route.icon,
          size: 40,
        ),
        text: r.route.name,
      )));
    });
    return iconButtons;
  }
}
