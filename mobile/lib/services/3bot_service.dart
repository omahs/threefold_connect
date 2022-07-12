import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:package_info/package_info.dart';
import 'package:threebotlogin/app_config.dart';
import 'package:threebotlogin/helpers/globals.dart';
import 'package:threebotlogin/services/crypto_service.dart';
import 'package:threebotlogin/services/shared_preference_service.dart';

String threeBotApiUrl = AppConfig().threeBotApiUrl();
Map<String, String> requestHeaders = {'Content-type': 'application/json'};

Future<Response> sendSignedData(
    String state, String socketRoom, String signedDataIdentifier, String appId, String dataHash) async {
  Uri url = Uri.parse('$threeBotApiUrl/sign/signed-attempt');
  print('Sending call: ${url.toString()}');

  String timestamp = new DateTime.now().millisecondsSinceEpoch.toString();

  Uint8List sk = await getPrivateKey();
  String encodedBody = jsonEncode({
    'signedAttempt': await signData(
        json.encode({
          'signedState': state,
          'signedOn': timestamp,
          'randomRoom': socketRoom,
          'appId': appId,
          'signedData': signedDataIdentifier,
          'doubleName': await getDoubleName(),
          'dataHash': dataHash
        }),
        sk),
    'doubleName': await getDoubleName()
  });

  return http.post(url, body: encodedBody, headers: requestHeaders);
}

Future<Response> sendData(
    String state, Map<String, String>? data, selectedImageId, String? randomRoom, String appId) async {
  Uri url = Uri.parse('$threeBotApiUrl/login/signed-attempt');
  print('Sending call: ${url.toString()}');

  String encodedBody = json.encode({
    'signedAttempt': await signData(
        json.encode({
          'signedState': state,
          'data': data,
          'selectedImageId': selectedImageId,
          'doubleName': await getDoubleName(),
          'randomRoom': randomRoom,
          'appId': appId
        }),
        await getPrivateKey()),
    'doubleName': await getDoubleName()
  });

  return http.post(url, body: encodedBody, headers: requestHeaders);
}

Future<Response> addDigitalTwinDerivedPublicKeyToBackend(name, publicKey, appId) async {
  Uri url = Uri.parse('$threeBotApiUrl/digitaltwin/$name');
  print('Sending call: ${url.toString()}');

  Uint8List sk = await getPrivateKey();
  String encodedData = json.encode({'username': name, 'derivedPublicKey': publicKey, 'appId': appId});
  String signedData = await signData(encodedData, sk);

  Map<String, String> data = { "data" : signedData };

  return http.post(url, body: json.encode(data), headers: requestHeaders);
}

Future<Response> sendPublicKey(Map<String, Object> data) async {
  Uri url = Uri.parse('$threeBotApiUrl/savederivedpublickey');
  print('Sending call: ${url.toString()}');

  String timestamp = new DateTime.now().millisecondsSinceEpoch.toString();
  Uint8List sk = await getPrivateKey();

  Map<String, String> headers = {"timestamp": timestamp, "intention": "post-savederivedpublickey"};
  String signedHeaders = await signData(jsonEncode(headers), sk);

  Map<String, String> loginRequestHeaders = {'Content-type': 'application/json', 'Jimber-Authorization': signedHeaders};

  return http.post(url, body: json.encode(data), headers: loginRequestHeaders);
}

Future<Response> sendProductReservation(Map<String, Object> data) async {
  Uri url = Uri.parse('$threeBotApiUrl/digitaltwin/productkey');
  print('Sending call: ${url.toString()}');

  Uint8List sk = await getPrivateKey();
  String? doubleName = await getDoubleName();

  String signedData = await signData(jsonEncode(data), sk);

  var body = json.encode({"doubleName": doubleName, "data": signedData});
  return await http.put(url, body: body, headers: {'Content-type': 'application/json'});
}

Future<bool> isAppUpToDate() async {
  Uri url = Uri.parse('$threeBotApiUrl/minimumversion');
  print('Sending call: ${url.toString()}');

  PackageInfo packageInfo = await PackageInfo.fromPlatform();

  int currentBuildNumber = int.parse(packageInfo.buildNumber);
  int minimumBuildNumber = 0;

  String jsonResponse =
      (await http.get(url, headers: requestHeaders).timeout(Duration(seconds: Globals().timeOutSeconds))).body;

  Map<String, dynamic> minimumVersion = json.decode(jsonResponse);

  if (Platform.isAndroid) {
    minimumBuildNumber = minimumVersion['android'];
  } else if (Platform.isIOS) {
    minimumBuildNumber = minimumVersion['ios'];
  }

  return currentBuildNumber >= minimumBuildNumber;
}

Future<bool> isAppUnderMaintenance() async {
  Uri url = Uri.parse('$threeBotApiUrl/maintenance');
  print('Sending call: ${url.toString()}');

  Response response = await http.get(url, headers: requestHeaders).timeout(Duration(seconds: Globals().timeOutSeconds));

  if (response.statusCode != 200) {
    return false;
  }

  Map<String, dynamic> mappedResponse = json.decode(response.body);
  return mappedResponse['maintenance'] == 1;
}

Future<bool> checkIfPkidIsAvailable() async {
  Uri url = Uri.parse(AppConfig().pKidUrl());
  print('Sending call: ${url.toString()}');

  Response response = await http.get(url, headers: requestHeaders).timeout(Duration(seconds: Globals().timeOutSeconds));

  if (response.statusCode != 200) {
    return false;
  }

  return true;
}

Future<Response> cancelLogin(doubleName) {
  Uri url = Uri.parse('$threeBotApiUrl/login/$doubleName/cancel');
  print('Sending call: ${url.toString()}');

  return http.post(url, body: null, headers: requestHeaders);
}

Future<Response> cancelSign(doubleName) {
  Uri url = Uri.parse('$threeBotApiUrl/sign/$doubleName/cancel');
  print('Sending call: ${url.toString()}');

  return http.post(url, body: null, headers: requestHeaders);
}

Future<Response> getUserInfo(doubleName) {
  Uri url = Uri.parse('$threeBotApiUrl/users/$doubleName');
  print('Sending call: ${url.toString()}');

  return http.get(url, headers: requestHeaders);
}

Future<Response> finishRegistration(String doubleName, String email, String sid, String publicKey) async {
  Uri url = Uri.parse('$threeBotApiUrl/users');
  print('Sending call: ${url.toString()}');

  return http.post(url,
      body: json.encode({
        'username': doubleName + '.3bot',
        'sid': sid,
        'email': email.toLowerCase().trim(),
        'public_key': publicKey
      }),
      headers: requestHeaders);
}
