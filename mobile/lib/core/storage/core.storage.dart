import 'dart:convert';
import 'dart:typed_data';
import 'dart:core';
import 'package:convert/convert.dart';

import 'package:flutter_sodium/flutter_sodium.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Initialization
Future<bool> getInitialized() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  bool? initDone = prefs.getBool('initDone');
  if (initDone == null) {
    prefs.setBool('initDone', false);
    initDone = prefs.getBool('initDone');
  }

  bool isInitDone = initDone == true;
  return isInitDone;
}

Future<void> setInitialized() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool('initDone', true);
}

// Username
Future<String?> getUsername() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('doubleName');
}

Future<void> setUsername(String username) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('doubleName', username);
}

// Crypto stuff

Future<void> setPhrase(String phrase) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove('phrase');
  prefs.setString('phrase', phrase);
}

Future<String?> getPhrase() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('phrase');
}

Future<Uint8List> getPrivateKey() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  String? privateKey = prefs.getString('privatekey');
  Uint8List decodedPrivateKey = base64.decode(privateKey!);
  return decodedPrivateKey;
}

Future<void> setPrivateKey(Uint8List privateKey) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  String encodedPrivateKey = base64.encode(privateKey);
  prefs.setString('privatekey', encodedPrivateKey);
}

Future<Uint8List> getPublicKey() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  String? privateKey = prefs.getString('publickey');
  Uint8List decodedPrivateKey = base64.decode(privateKey!);
  return decodedPrivateKey;
}

Future<void> setPublicKey(Uint8List privateKey) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  String encodedPrivateKey = base64.encode(privateKey);
  prefs.setString('publickey', encodedPrivateKey);
}

Future<Map<String, String>> getEdCurveKeys() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  final String? pkEd = prefs.getString('publickey');
  final String? skEd = prefs.getString('privatekey');

  final String pkCurve = base64.encode(Sodium.cryptoSignEd25519PkToCurve25519(base64.decode(pkEd!)));
  final String skCurve = base64.encode(Sodium.cryptoSignEd25519SkToCurve25519(base64.decode(skEd!)));

  return {
    'signingPublicKey': hex.encode(base64.decode(pkEd)),
    'signingPrivateKey': hex.encode(base64.decode(skEd)),
    'encryptionPublicKey': hex.encode(base64.decode(pkCurve)),
    'encryptionPrivateKey': hex.encode(base64.decode(skCurve))
  };
}
