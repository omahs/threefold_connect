import 'package:flutter/material.dart';
import 'package:threebotlogin/core/router/classes/router.classes.dart';
import 'package:threebotlogin/core/storage/globals.storage.dart';
import 'package:threebotlogin/views/home/home.view.dart';
import 'package:threebotlogin/views/identity/identity.view.dart';
import 'package:threebotlogin/views/news/news.view.dart';
import 'package:threebotlogin/views/settings/settings.view.dart';
import 'package:threebotlogin/views/wallet/wallet.view.dart';
import 'package:threebotlogin/views/yggdrasil/yggdrasil.view.dart';

List<AppInfo> routes = [
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
        icon: Icons.newspaper,
        canSee: Globals().canSeeNews,
        view: NewsScreen(),
      ),
      app: null),
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
        view: NewsScreen(),
      ),
      app: null),
  AppInfo(
      route: JRoute(
        path: '/support',
        name: 'Support',
        icon: Icons.chat,
        canSee: Globals().canSeeSupport,
        view: NewsScreen(),
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
