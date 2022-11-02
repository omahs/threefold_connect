import 'dart:convert';
import 'dart:typed_data';

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

// KYC

Future<Map<String, String?>> getEmail() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return {'email': prefs.getString('email'), 'sei': prefs.getString('signedEmailIdentifier')};
}

Future<void> setEmail(String email, String? signedEmailIdentifier) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('email', email);

  if (signedEmailIdentifier != null) {
    prefs.setString('signedEmailIdentifier', signedEmailIdentifier);
  }
}

Future<bool> getFingerPrint() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  bool? fingerprint = prefs.getBool('useFingerPrint');
  if (fingerprint == null) {
    prefs.setBool('useFingerPrint', false);
    fingerprint = prefs.getBool('useFingerPrint');
  }

  bool hasFingerprint = fingerprint == true;
  return hasFingerprint;
}

Future<void> setFingerPrint(fingerprint) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool('useFingerPrint', fingerprint);
}

Future<Map<String, String?>> getPhone() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return {'phone': prefs.getString('phone'), 'spi': prefs.getString('signedPhoneIdentifier')};
}

Future<void> setPhone(String phone, String? signedPhoneIdentifier) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  prefs.setString('phone', phone);
  if (signedPhoneIdentifier != null) {
    prefs.setString('signedPhoneIdentifier', signedPhoneIdentifier);
  }
}
