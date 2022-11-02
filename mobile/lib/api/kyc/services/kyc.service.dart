import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:threebotlogin/app_config.dart';
import 'package:threebotlogin/core/crypto/services/crypto.services.dart';
import 'package:threebotlogin/core/storage/core.storage.dart';

String openKycApiUrl = AppConfig().openKycApiUrl();
String threeBotApiUrl = AppConfig().threeBotApiUrl();

Map<String, String> requestHeaders = {'Content-type': 'application/json'};

Future<Response> getSignedEmailIdentifierFromOpenKYC(String doubleName) async {
  String timestamp = new DateTime.now().millisecondsSinceEpoch.toString();
  Uint8List sk = await getPrivateKey();

  Map<String, String> payload = {"timestamp": timestamp, "intention": "get-signedemailidentifier"};
  String signedPayload = await signData(jsonEncode(payload), sk);

  Map<String, String> loginRequestHeaders = {'Content-type': 'application/json', 'Jimber-Authorization': signedPayload};

  Uri url = Uri.parse('$openKycApiUrl/verification/retrieve-sei/$doubleName');
  print('Sending call: ${url.toString()}');

  return http.get(url, headers: loginRequestHeaders);
}

Future<Response> getSignedPhoneIdentifierFromOpenKYC(String doubleName) async {
  String timestamp = new DateTime.now().millisecondsSinceEpoch.toString();
  Uint8List sk = await getPrivateKey();

  Map<String, String> payload = {"timestamp": timestamp, "intention": "get-signedphoneidentifier"};
  String signedPayload = await signData(jsonEncode(payload), sk);

  Map<String, String> loginRequestHeaders = {'Content-type': 'application/json', 'Jimber-Authorization': signedPayload};

  Uri url = Uri.parse('$openKycApiUrl/verification/retrieve-spi/$doubleName');
  print('Sending call: ${url.toString()}');

  return http.get(url, headers: loginRequestHeaders);
}

Future<Response> verifySignedEmailIdentifierFromOpenKYC(String signedEmailIdentifier) async {
  Uri url = Uri.parse('$openKycApiUrl/verification/verify-sei');
  print('Sending call: ${url.toString()}');

  return http.post(url, body: json.encode({"signedEmailIdentifier": signedEmailIdentifier}), headers: requestHeaders);
}

Future<Response> verifySignedPhoneIdentifierFromOpenKYC(String signedPhoneIdentifier) async {
  Uri url = Uri.parse('$openKycApiUrl/verification/verify-spi');
  print('Sending call: ${url.toString()}');

  return http.post(url, body: json.encode({"signedPhoneIdentifier": signedPhoneIdentifier}), headers: requestHeaders);
}
