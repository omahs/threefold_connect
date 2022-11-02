import 'package:flagsmith/flagsmith.dart';
import 'package:threebotlogin/app_config.dart';
import 'package:threebotlogin/core/flagsmith/services/flagsmith.service.dart';
import 'package:threebotlogin/core/storage/core.storage.dart';
import 'package:threebotlogin/core/storage/globals.storage.dart';

class Flags {
  static final Flags _singleton = new Flags._internal();

  late FlagsmithClient client;

  Map<String, String> flagSmithConfig = AppConfig().flagSmithConfig();

  Future<void> initFlagSmith() async {
    try {
      client = await FlagsmithClient.init(
          config: FlagsmithConfig(baseURI: flagSmithConfig['url']!), apiKey: flagSmithConfig['apiKey']!);

      String? username = await getUsername();
      if (username == null) {
        await client.getFeatureFlags(reload: true);
        return;
      }

      Identity user = Identity(identifier: username);
      await setDeviceTrait(user);
      await client.getFeatureFlags(user: user, reload: true);
    } catch (e) {
      setFallbackConfigs();
      throw Exception('Error in in FlagSmith, please try again. If this issue persist, please contact support');
    }
  }

  Future<void> setFlagSmithDefaultValues() async {
    Globals().maintenance = await Flags().hasFlagValueByFeatureName('maintenance');
    Globals().canSeeNews = await Flags().hasFlagValueByFeatureName('can-see-news');
    Globals().canSeeWallet = await Flags().hasFlagValueByFeatureName('can-see-wallet');
    Globals().useNewWallet = await Flags().hasFlagValueByFeatureName('use-new-wallet');
    Globals().canSeeSupport = await Flags().hasFlagValueByFeatureName('can-see-support');
    Globals().canSeeYggdrasil = await Flags().hasFlagValueByFeatureName('can-see-yggdrasil');
    Globals().canSeeKyc = await Flags().hasFlagValueByFeatureName('can-see-kyc');
    Globals().canVerifyEmail = await Flags().hasFlagValueByFeatureName('can-verify-email');
    Globals().canVerifyPhone = await Flags().hasFlagValueByFeatureName('can-verify-phone');
    Globals().canSeeFarmer = await Flags().hasFlagValueByFeatureName('can-see-farmer');

    Globals().newWalletUrl = (await Flags().getFlagValueByFeatureName('new-wallet-url'))!;
    Globals().newsUrl = (await Flags().getFlagValueByFeatureName('news-url'))!;
    Globals().oldWalletUrl = (await Flags().getFlagValueByFeatureName('old-wallet-url'))!;
    Globals().farmerUrl = (await Flags().getFlagValueByFeatureName('farmer-url'))!;
    Globals().supportUrl = (await Flags().getFlagValueByFeatureName('chatbot-url'))!;
    Globals().termsAndConditionsUrl = (await Flags().getFlagValueByFeatureName('terms-and-conditions-url'))!;
  }

  Future<bool> hasFlagValueByFeatureName(String name) async {
    String? username = await getUsername();

    if (username == null) {
      return (await client.hasFeatureFlag(name));
    }

    Identity user = Identity(identifier: username);
    return (await client.hasFeatureFlag(name, user: user));
  }

  Future<String?> getFlagValueByFeatureName(String name) async {
    String? username = await getUsername();

    if (username == null) {
      return (await client.getFeatureFlagValue(name));
    }

    Identity user = Identity(identifier: username);
    return (await client.getFeatureFlagValue(name, user: user));
  }

  Future<dynamic> setDeviceTrait(Identity user) async {
    String info = await getDeviceInfo();
    TraitWithIdentity trait = new TraitWithIdentity(identity: user, key: 'device', value: info);
    return (await client.createTrait(value: trait));
  }

  factory Flags() {
    return _singleton;
  }

  Flags._internal();
}
