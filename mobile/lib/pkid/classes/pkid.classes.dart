import 'package:flutter_sodium/flutter_sodium.dart';
import 'package:threebotlogin/app_config.dart';
import 'package:threebotlogin/core/crypto/services/crypto.service.dart';
import 'package:flutter_pkid/flutter_pkid.dart';
import 'package:threebotlogin/core/events/classes/event.classes.dart';
import 'package:threebotlogin/core/events/services/events.service.dart';
import 'package:threebotlogin/core/storage/core.storage.dart';
import 'package:threebotlogin/core/storage/globals.storage.dart';
import 'package:threebotlogin/core/storage/kyc/kyc.storage.dart';
import 'package:threebotlogin/pkid/helpers/pkid.helpers.dart';

class PkidClient {
  late String username;
  late String phrase;

  PkidClient(this.username, this.phrase);

  Future<void> initializePkidClient() async {
    String pKidUrl = AppConfig().pKidUrl();

    KeyPair keyPair = generateKeyPairFromMnemonic(phrase);
    Globals().pkidClient = FlutterPkid(pKidUrl, keyPair);

    await _addMigrationIfNeeded();
    await getEmailFromPkidAndStore();
    await getPhoneFromPkidAndStore();

    print('[PKID] Client established for user $username');

    Events().onEvent(DisconnectPkidClient().runtimeType, (DisconnectPkidClient event) async {
      print('[PKID] Client disconnected');
      disconnectClient();
    });
  }

  Future<void> getEmailFromPkidAndStore() async {
    Map<String, dynamic> emailData = await getEmailFromPKid();

    if (emailData['email'] == null) return;

    Map<String, String?> email = emailData['email'];
    if (email['email'] != null) {
      await setEmail((email['email'])!, email['sei']);
    }
  }

  Future<void> getPhoneFromPkidAndStore() async {
    Map<String, dynamic> phoneData = await getPhoneFromPkid();

    if (phoneData['phone'] == null) return;

    Map<String, String?> phone = phoneData['phone'];
    if (phone['phone'] != null) {
      await setPhone((phone['phone'])!, phone['spi']);
    }
  }

  Future<void> _addMigrationIfNeeded() async {
    bool isMigrated = await getIsMigratedInPkid();
    if (isMigrated) return;

    await saveEmailToPKidForMigration();
    await savePhoneToPKidForMigration();

    await setIsMigratedInPkid();
  }

  FlutterPkid? getClient() {
    return Globals().pkidClient;
  }

  void disconnectClient() {
    Globals().pkidClient = null;
  }
}
