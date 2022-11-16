import 'package:flutter/material.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:threebotlogin/core/components/dialogs/custom.dialog.core.dart';
import 'package:threebotlogin/core/storage/globals.storage.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:threebotlogin/core/styles/color.styles.dart';
import 'package:threebotlogin/views/identity/helpers/identity.helpers.dart';

void showEmailResentDialog() async {
  return showDialog(
    context: Globals().globalBuildContext,
    barrierDismissible: false,
    builder: (BuildContext context) => CustomDialog(
      image: Icons.check,
      title: "Email has been resent.",
      description: "A new verification email has been sent.",
      actions: <Widget>[
        TextButton(
          child: new Text("Ok"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    ),
  );
}

void showSmsSentDialog() async {
  return showDialog(
    context: Globals().globalBuildContext,
    barrierDismissible: false,
    builder: (BuildContext context) => CustomDialog(
      image: Icons.check,
      title: "Sms has been sent.",
      description: "A verification sms has been sent.",
      actions: <Widget>[
        TextButton(
          child: new Text("Ok"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    ),
  );
}

Future<bool?> showVerifyNowDialog() async {
  return await showDialog(
    context: Globals().globalBuildContext,
    barrierDismissible: false,
    builder: (BuildContext context) => CustomDialog(
      image: Icons.info,
      title: "Verify phone number",
      description: "Do you want to verify your phone number now?",
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: Text('No')),
        TextButton(
            onPressed: () async {
              Navigator.pop(context, true);
            },
            child: Text('Yes'))
      ],
    ),
  );
}
