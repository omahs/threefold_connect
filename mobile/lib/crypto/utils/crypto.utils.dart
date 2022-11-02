import 'dart:convert';

import 'package:bip39/bip39.dart' as bip39;
import 'package:flutter_sodium/flutter_sodium.dart';
import 'package:threebotlogin/crypto/services/crypto.services.dart';

import '../../api/3bot/services/3bot.service.dart';
import 'transform.utils.dart';

bool canGenerateKeyPairFromMnemonic(String mnemonic) {
  try {
    String entropy = bip39.mnemonicToEntropy(mnemonic);
    Sodium.cryptoSignSeedKeypair(toHex(entropy));
    return true;
  } catch (e) {
    return false;
  }
}

Future<Map<String, dynamic>> isValidMnemonic(String mnemonic) async {
  int length = mnemonic.split(' ').length;

  if (length < 24) return {"valid": false, "reason": "Mnemonic is too short"};
  if (length > 24) return {"valid": false, "reason": "Mnemonic is too long"};

  bool isValidMnemonic = canGenerateKeyPairFromMnemonic(mnemonic);
  if (!isValidMnemonic) return {"valid": false, "reason": "Invalid mnemonic"};

  KeyPair kp = generateKeyPairFromMnemonic(mnemonic);
  String encodedPk = base64.encode(kp.pk);

  String? username = await getUsernameOfPublicKey(Uri.encodeComponent(encodedPk));
  if (username == null || username.isEmpty) {
    return {"valid": false, "reason": "No user found with the given mnemonic"};
  }

  return {"valid": true, "username": username};
}
