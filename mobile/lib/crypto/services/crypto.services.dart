import 'dart:convert';
import 'dart:typed_data';

import 'package:bip39/bip39.dart' as bip39;
import 'package:flutter_sodium/flutter_sodium.dart';

import '../utils/transform.utils.dart';

KeyPair generateKeyPairFromMnemonic(String mnemonic) {
  String entropy = bip39.mnemonicToEntropy(mnemonic);
  return Sodium.cryptoSignSeedKeypair(toHex(entropy));
}

Future<String> signData(String data, Uint8List sk) async {
  Uint8List signed = Sodium.cryptoSign(Uint8List.fromList(data.codeUnits), sk);
  return base64.encode(signed);
}
