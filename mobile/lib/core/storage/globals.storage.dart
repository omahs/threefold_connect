import 'package:flutter/material.dart';
import 'package:threebotlogin/core/router/classes/router.classes.dart';

class Globals {
  late BuildContext globalBuildContext;

  int loginTimeout = 120;
  int httpTimeout = 12;
  bool maintenance = true;

  bool canSeeNews = false;
  String newsUrl = 'https://news.threefold.me/';

  bool canSeeWallet = false;
  bool useNewWallet = true;
  String newWalletUrl = 'https://wallet-next.threefold.me/';
  String oldWalletUrl = 'https://wallet.threefold.me/';

  bool canSeeFarmer = false;
  String farmerUrl = 'https://farmer.threefold.me/';

  bool canSeeSupport = false;
  String supportUrl = 'https://go.crisp.chat/chat/embed/?website_id=1a5a5241-91cb-4a41-8323-5ba5ec574da0&user_email=';

  bool canSeeYggdrasil = false;

  bool canSeeKyc = false;
  bool canVerifyPhone = false;
  bool canVerifyEmail = false;

  bool canSeeWizard = false;
  String wizardUrl = 'https://wizard.jimber.org';

  String termsAndConditionsUrl = 'https://library.threefold.me/info/legal/#/';


  int incorrectPinAttempts = 0;
  int lockedUntil = 0;

  bool isWalletCacheCleared = false;
  bool isFarmerCacheCleared = false;

  late TabController tabController;
  final JRouter router = new JRouter();

  static final Globals _singleton = new Globals._internal();

  factory Globals() {
    return _singleton;
  }

  Globals._internal();
}
