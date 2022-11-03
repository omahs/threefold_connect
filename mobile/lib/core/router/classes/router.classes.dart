import 'package:flutter/material.dart';
import 'package:threebotlogin/app.dart';
import 'package:threebotlogin/core/storage/globals.storage.dart';
import 'package:threebotlogin/views/farmer/farmer.view.dart';
import 'package:threebotlogin/views/home/home.view.dart';
import 'package:threebotlogin/views/identity/identity.view.dart';
import 'package:threebotlogin/views/news/news.class.dart';
import 'package:threebotlogin/views/settings/settings.view.dart';
import 'package:threebotlogin/views/support/support.view.dart';
import 'package:threebotlogin/views/wallet/wallet.view.dart';
import 'package:threebotlogin/views/yggdrasil/yggdrasil.view.dart';

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
  List<AppInfo> routes = [];

  init() async {
    routes = [
      AppInfo(
          route: JRoute(
            path: '/',
            name: 'Home',
            icon: Icons.home,
            canSee: true,
            view: HomeScreen(),
          ),
          app: null),
      AppInfo(
          route: JRoute(
            path: '/news',
            name: 'News',
            icon: Icons.article,
            canSee: Globals().canSeeNews,
            view: await News().widget(),
          ),
          app: News()),
      AppInfo(
          route: JRoute(
            path: '/wallet',
            name: 'Wallet',
            icon: Icons.wallet,
            canSee: Globals().canSeeWallet,
            view: WalletScreen(),
          ),
          app: null),
      AppInfo(
          route: JRoute(
            path: '/farming',
            name: 'Farming',
            icon: Icons.person_pin,
            canSee: Globals().canSeeFarmer,
            view: FarmerScreen(),
          ),
          app: null),
      AppInfo(
          route: JRoute(
            path: '/support',
            name: 'Support',
            icon: Icons.chat,
            canSee: Globals().canSeeSupport,
            view: SupportScreen(),
          ),
          app: null),
      AppInfo(
          route: JRoute(
            path: '/yggdrasil',
            name: 'Planetary Network',
            icon: Icons.network_check,
            canSee: Globals().canSeeYggdrasil,
            view: YggDrasilScreen(),
          ),
          app: null),
      AppInfo(
          route: JRoute(
            path: '/identity',
            name: 'Identity',
            icon: Icons.person,
            canSee: Globals().canSeeKyc,
            view: IdentityScreen(),
          ),
          app: null),
      AppInfo(
          route: JRoute(
            path: '/settings',
            name: 'Settings',
            icon: Icons.settings,
            canSee: true,
            view: SettingsScreen(),
          ),
          app: null),
    ];
  }

  List<AppInfo> getAllRoutes() {
    return routes;
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
