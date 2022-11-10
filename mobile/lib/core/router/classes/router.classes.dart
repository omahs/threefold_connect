import 'package:flutter/material.dart';
import 'package:threebotlogin/core/storage/globals.storage.dart';
import 'package:threebotlogin/views/farmer/views/farmer.view.dart';
import 'package:threebotlogin/views/home/views/home.view.dart';
import 'package:threebotlogin/views/identity/identity.view.dart';
import 'package:threebotlogin/views/news/views/news.view.dart';
import 'package:threebotlogin/views/settings/settings.view.dart';
import 'package:threebotlogin/views/support/views/support.view.dart';
import 'package:threebotlogin/views/wallet/views/wallet.view.dart';
import 'package:threebotlogin/views/yggdrasil/views/yggdrasil.view.dart';

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
      )),
      AppInfo(
          route: JRoute(
        path: '/news',
        name: 'News',
        icon: Icons.article,
        canSee: Globals().canSeeNews,
        view: NewsScreen(),
      )),
      AppInfo(
          route: JRoute(
        path: '/wallet',
        name: 'Wallet',
        icon: Icons.wallet,
        canSee: Globals().canSeeWallet,
        pinRequired: true,
        view: WalletScreen(),
      )),
      AppInfo(
          route: JRoute(
        path: '/farming',
        name: 'Farming',
        icon: Icons.person_pin,
        canSee: Globals().canSeeFarmer,
        pinRequired: true,
        view: FarmerScreen(),
      )),
      AppInfo(
          route: JRoute(
        path: '/support',
        name: 'Support',
        icon: Icons.chat,
        canSee: Globals().canSeeSupport,
        view: SupportScreen(),
      )),
      AppInfo(
          route: JRoute(
        path: '/yggdrasil',
        name: 'Planetary Network',
        icon: Icons.network_check,
        canSee: Globals().canSeeYggdrasil,
        view: YggDrasilScreen(),
      )),
      AppInfo(
          route: JRoute(
        path: '/identity',
        name: 'Identity',
        icon: Icons.person,
        canSee: Globals().canSeeKyc,
        view: IdentityScreen(),
      )),
      AppInfo(
          route: JRoute(
        path: '/settings',
        name: 'Settings',
        icon: Icons.settings,
        canSee: true,
        view: SettingsScreen(),
      )),
    ];
  }

  List<Widget> getContent() {
    List<Widget> containers = [];
    routes.forEach((r) {
      containers.add(r.route.view);
    });
    return containers;
  }

  bool pinRequired(int index) {
    if (routes[index].route.pinRequired != null) {
      return true;
    }
    return false;
  }
}

class AppInfo {
  JRoute route;

  AppInfo({required this.route});
}
