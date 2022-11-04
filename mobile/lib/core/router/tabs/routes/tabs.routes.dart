import 'package:flutter/material.dart';
import 'package:threebotlogin/core/router/classes/router.classes.dart';
import 'package:threebotlogin/core/storage/globals.storage.dart';
import 'package:threebotlogin/views/farmer/views/farmer.view.dart';
import 'package:threebotlogin/views/home/views/home.view.dart';
import 'package:threebotlogin/views/identity/identity.view.dart';
import 'package:threebotlogin/views/news/views/news.view.dart';
import 'package:threebotlogin/views/settings/settings.view.dart';
import 'package:threebotlogin/views/support/support.view.dart';
import 'package:threebotlogin/views/wallet/views/wallet.view.dart';
import 'package:threebotlogin/views/yggdrasil/yggdrasil.view.dart';

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