import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:threebotlogin/core/components/dialogs/custom.dialog.core.dart';
import 'package:threebotlogin/views/identity/helpers/identity.helpers.dart';

class PhoneNumberDialog extends StatefulWidget {
  final String defaultCountryCode;

  const PhoneNumberDialog({Key? key, required this.defaultCountryCode}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new PhoneNumberDialogState();
  }
}

class PhoneNumberDialogState extends State<PhoneNumberDialog> {
  bool valid = true;
  String verificationPhoneNumber = '';

  @override
  void initState() {
    valid = false;
    verificationPhoneNumber = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
        image: Icons.phone,
        title: "Add phone number",
        widgetDescription: SizedBox(
          height: 100,
          child: Column(children: [
            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: IntlPhoneField(
                      initialCountryCode: widget.defaultCountryCode,
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(),
                        ),
                      ),
                      onChanged: (phone) {
                        PhoneNumber p = phone;

                        RegExp regExp = new RegExp(
                          r"^(\+[0-9]{1,3}|0)[0-9]{3}( ){0,1}[0-9]{7,8}\b$",
                          caseSensitive: false,
                          multiLine: false,
                        );

                        setState(() {
                          valid = regExp.hasMatch(p.completeNumber.replaceAll('\n', ''));
                          verificationPhoneNumber = p.completeNumber;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ]),
        ),
        actions: <Widget>[
          new TextButton(
              child: const Text(
                'Cancel',
              ),
              onPressed: () {
                valid = isValidPhoneNumber(verificationPhoneNumber);
                setState(() {});
                Navigator.pop(context);
              }),
          new TextButton(
              child: const Text('Add', style: const TextStyle(color: Colors.white)),
              style: TextButton.styleFrom(backgroundColor: valid ? Colors.blue : Colors.grey),
              onPressed: () {
                valid = isValidPhoneNumber(verificationPhoneNumber);
                if (!valid) return;
                return Navigator.pop(context, verificationPhoneNumber);
              })
        ]);
  }
}
