import 'package:flutter/material.dart';
import 'package:flutter_sodium/flutter_sodium.dart';
import 'package:threebotlogin/core/storage/core.storage.dart';
import 'package:threebotlogin/crypto/services/crypto.services.dart';

import '../core/components/dividers/box.dividers.dart';
import '../core/styles/color.styles.dart';
import '../crypto/utils/crypto.utils.dart';

class RecoverScreen extends StatefulWidget {
  RecoverScreen();

  _RecoverScreenState createState() => _RecoverScreenState();
}

class _RecoverScreenState extends State<RecoverScreen> {
  _RecoverScreenState();

  String? recoverError;

  final TextEditingController mnemonicController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kAppBarColor,
        title: Text('Recover Account'),
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [labelSeedPhrase, kSizedBoxSm, seedPhraseInputField(), errorText(), kSizedBoxMd, recoverButton()],
        ),
      ),
    );
  }

  Widget errorText() {
    if (recoverError == null) return Container();
    return Container(
        padding: EdgeInsets.only(top: 8),
        child: Text(
          recoverError!,
          style: TextStyle(color: kErrorColor, fontWeight: FontWeight.bold),
        ));
  }

  Widget labelSeedPhrase = Container(
      child: Text(
    'Enter your existing 24 worded mnemonic seed',
    textAlign: TextAlign.left,
    style: TextStyle(fontWeight: FontWeight.bold),
  ));

  Widget recoverButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: kThreeFoldGreenColor, padding: EdgeInsets.all(12)),
      onPressed: () => recoverAccount(),
      child: Text('RECOVER'),
    );
  }

  Widget seedPhraseInputField() {
    return Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
        child: TextFormField(
          controller: mnemonicController,
          decoration: new InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
              hintText: "Your 24 worded mnemonic seed"),
        ));
  }

  void recoverAccount() async {
    String? mnemonic = mnemonicController.text;
    String formattedMnemonic = mnemonic.trim().toLowerCase().replaceAll('  ', ' ');

    Map<String, dynamic> validationMnemonic = await isValidMnemonic(formattedMnemonic);
    if (!validationMnemonic['valid']) {
      setState(() => recoverError = validationMnemonic['reason']);
      return;
    }

    setState(() => recoverError = null);
    await saveDataToLocalStorage(mnemonic, validationMnemonic['username']);
    Navigator.pop(context, true);
  }

  Future<void> saveDataToLocalStorage(String mnemonic, String username) async {
    KeyPair kp = generateKeyPairFromMnemonic(mnemonic);

    await setPrivateKey(kp.sk);
    await setPublicKey(kp.pk);

    await setUsername(username);
    await setFingerPrint(false);
  }
}
