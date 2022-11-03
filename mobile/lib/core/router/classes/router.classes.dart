import 'package:flutter/material.dart';
import 'package:threebotlogin/core/storage/globals.storage.dart';
import 'package:threebotlogin/views/farmer/farmer.view.dart';
import 'package:threebotlogin/views/home/home.view.dart';
import 'package:threebotlogin/views/identity/identity.view.dart';
import 'package:threebotlogin/views/news/news.view.dart';
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

class JRouter {
  List<AppInfo> routes = [
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
      pinRequired: true,
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
