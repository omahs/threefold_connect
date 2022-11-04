import 'package:flutter/material.dart';
import 'package:threebotlogin/core/auth/pin/views/change.pin.view.dart';
import 'package:threebotlogin/core/components/dividers/box.dividers.dart';
import 'package:threebotlogin/core/crypto/utils/crypto.utils.dart';
import 'package:threebotlogin/core/events/classes/event.classes.dart';
import 'package:threebotlogin/core/events/services/events.service.dart';
import 'package:threebotlogin/core/flagsmith/classes/flagsmith.class.dart';
import 'package:threebotlogin/core/styles/color.styles.dart';
import 'package:threebotlogin/views/home/views/home.view.dart';
import 'package:threebotlogin/views/recover/helpers/recover.helpers.dart';
import 'package:threebotlogin/views/recover/widgets/recover.widgets.dart';

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
          children: [
            labelSeedPhrase,
            kSizedBoxSm,
            seedPhraseInputField(),
            errorText(recoverError),
            kSizedBoxMd,
            recoverButton(recoverAccount)
          ],
        ),
      ),
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
    await saveRecoverDataToLocalStorage(mnemonic, validationMnemonic['username']);

    await Flags().initFlagSmith();
    await Flags().setFlagSmithDefaultValues();


    await Navigator.push(context, MaterialPageRoute(builder: (context) => ChangePinScreen(hideBackButton: true)));


    Events().emit(RecoveredEvent());
    Navigator.of(context).popUntil((route) => route.isFirst);
    await Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
  }
}
