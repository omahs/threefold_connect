import 'dart:convert';
import 'dart:typed_data';
import 'dart:async';

import 'package:bip39/bip39.dart' as bip39;
import 'package:flutter_sodium/flutter_sodium.dart';
import 'package:threebotlogin/core/crypto/utils/transform.utils.dart';
import 'package:threebotlogin/core/storage/core.storage.dart';
import 'package:pbkdf2ns/pbkdf2ns.dart';
import 'package:crypto/crypto.dart';

KeyPair generateKeyPairFromMnemonic(String mnemonic) {
  String entropy = bip39.mnemonicToEntropy(mnemonic);
  return Sodium.cryptoSignSeedKeypair(toHex(entropy));
}

Future<String> signData(String data, Uint8List sk) async {
  Uint8List signed = Sodium.cryptoSign(Uint8List.fromList(data.codeUnits), sk);
  return base64.encode(signed);
}

Future<Uint8List> generateDerivedSeed(String appId) async {
  Uint8List privateKey = await getPrivateKey();
  String encodedPrivateKey = base64.encode(privateKey);

  PBKDF2NS generator = PBKDF2NS(hash: sha256);
  List<int> hashKey = generator.generateKey(encodedPrivateKey, appId, 1000, 32);

  return new Uint8List.fromList(hashKey);
}
