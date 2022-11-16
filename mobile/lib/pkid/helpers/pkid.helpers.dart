import 'dart:convert';

import 'package:threebotlogin/core/storage/globals.storage.dart';
import 'package:threebotlogin/core/storage/kyc/kyc.storage.dart';

Future<void> saveEmailToPKidForMigration() async {
  Map<String, String?> email = await getEmail();
  var emailPKidResult = await Globals().pkidClient?.getPKidDoc('email');

  // Email is not in PKID yet
  if (!emailPKidResult.containsKey('success') && email['email'] != null) {
    if (email['sei'] != null) {
      await Globals().pkidClient?.setPKidDoc('email', json.encode({'email': email['email'], 'sei': email['sei']}));
      return;
    }

    if (email['email'] != null) {
      await Globals().pkidClient?.setPKidDoc('email', json.encode({'email': email['email']}));
      return;
    }
  }

  await Globals().pkidClient?.setPKidDoc('email', json.encode({'email': null}));
}

Future<void> savePhoneToPKidForMigration() async {
  Map<String, String?> phone = await getPhone();
  var phonePKidResult = await Globals().pkidClient?.getPKidDoc('phone');

  // Phone is not in PKID yet
  if (!phonePKidResult.containsKey('success') && phone['phone'] != null) {
    if (phone['spi'] != null) {
      await Globals().pkidClient?.setPKidDoc('phone', json.encode({'phone': phone['phone'], 'spi': phone['spi']}));
      return;
    }

    if (phone['phone'] != null) {
      await Globals().pkidClient?.setPKidDoc('phone', json.encode({'phone': phone}));
      return;
    }
  }

  await Globals().pkidClient?.setPKidDoc('phone', json.encode({'phone': null}));
}

Future<void> saveEmailToPKid() async {
  Map<String, String?> email = await getEmail();

  if (email['sei'] != null) {
    await Globals().pkidClient?.setPKidDoc('email', json.encode({'email': email['email'], 'sei': email['sei']}));
    return;
  }

  if (email['email'] != null) {
    await Globals().pkidClient?.setPKidDoc('email', json.encode({'email': email['email']}));
    return;
  }
}

Future<void> savePhoneToPKid() async {
  Map<String, String?> phone = await getPhone();

  if (phone['spi'] != null) {
    await Globals().pkidClient?.setPKidDoc('phone', json.encode({'phone': phone['phone'], 'spi': phone['spi']}));
    return;
  }

  if (phone['phone'] != null) {
    await Globals().pkidClient?.setPKidDoc('phone', json.encode({'phone': phone['phone']}));
    return;
  }
}

Future<dynamic> getEmailFromPKid() async {
  return await Globals().pkidClient?.getPKidDoc('email');
}

Future<dynamic> getPhoneFromPkid() async {
  return await Globals().pkidClient?.getPKidDoc('phone');
}
