import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:threebotlogin/core/storage/globals.storage.dart';

Future<void> setToClipboard(String text) async {
  Clipboard.setData(new ClipboardData(text: text));
  final snackBar = SnackBar(content: Text('Address copied to clipboard'));

  ScaffoldMessenger.of(Globals().globalBuildContext).showSnackBar(snackBar);
}
