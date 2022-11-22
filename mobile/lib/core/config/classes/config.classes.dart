import 'package:threebotlogin/core/config/classes/config.local.dart';
import 'package:threebotlogin/core/config/config.dart';
import 'package:threebotlogin/core/config/enums/config.enums.dart';
import 'package:threebotlogin/core/storage/globals.storage.dart';

class AppConfig extends EnvConfig {
  late AppConfigImpl appConfig;

  AppConfig() {
    if (environment == Environment.Staging) {
      appConfig = AppConfigStaging();
    } else if (environment == Environment.Production) {
      appConfig = AppConfigProduction();
    } else if (environment == Environment.Local) {
      appConfig = AppConfigLocal();
    }
  }

  String baseUrl() {
    return appConfig.baseUrl();
  }

  String openKycApiUrl() {
    return appConfig.openKycApiUrl();
  }

  String threeBotApiUrl() {
    return appConfig.threeBotApiUrl();
  }

  String threeBotSocketUrl() {
    return appConfig.threeBotSocketUrl();
  }

  String wizardUrl() {
    return appConfig.wizardUrl();
  }

  String pKidUrl() {
    return appConfig.pKidUrl();
  }

  Map<String, String> flagSmithConfig() {
    return appConfig.flagSmithConfig();
  }
}

abstract class AppConfigImpl {
  String baseUrl();

  String openKycApiUrl();

  String threeBotApiUrl();

  String threeBotSocketUrl();

  String wizardUrl();

  String pKidUrl();

  Map<String, String> flagSmithConfig();
}

class AppConfigProduction extends AppConfigImpl {
  String baseUrl() {
    return Globals().baseUrl;
  }

  String openKycApiUrl() {
    return Globals().kycUrl;
  }

  String threeBotApiUrl() {
    return Globals().apiUrl;
  }

  String threeBotSocketUrl() {
    return Globals().socketUrl;
  }

  String wizardUrl() {
    return Globals().wizardUrl;
  }

  String pKidUrl() {
    return Globals().pkidUrl;
  }

  Map<String, String> flagSmithConfig() {
    return {'url': 'https://flagsmith.jimber.io/api/v1/', 'apiKey': 'BuzktmbcnMJ77vznU7WhJB'};
  }
}

class AppConfigStaging extends AppConfigImpl {
  String baseUrl() {
    return Globals().baseUrl;
  }

  String openKycApiUrl() {
    return Globals().kycUrl;
  }

  String threeBotApiUrl() {
    return Globals().apiUrl;
  }

  String threeBotSocketUrl() {
    return Globals().socketUrl;
  }

  String wizardUrl() {
    return Globals().wizardUrl;
  }

  String pKidUrl() {
    return Globals().pkidUrl;
  }

  Map<String, String> flagSmithConfig() {
    return {'url': 'https://flagsmith.jimber.io/api/v1/', 'apiKey': 'n6YyxDdrePqwAF49KCYx7S'};
  }
}
