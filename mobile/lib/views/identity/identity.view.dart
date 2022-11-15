import 'package:flutter/material.dart';
import 'package:threebotlogin/core/router/tabs/views/tabs.views.dart';
import 'package:threebotlogin/core/storage/kyc/kyc.storage.dart';

class IdentityScreen extends StatefulWidget {
  IdentityScreen();

  _IdentityScreenState createState() => _IdentityScreenState();
}

class _IdentityScreenState extends State<IdentityScreen> {
  _IdentityScreenState();

  late bool isEmailVerified = false;
  late bool isPhoneVerified = false;

  late String? email = '';
  late String? phone = '';

  @override
  Widget build(BuildContext context) {
    return LayoutDrawer(
        titleText: 'Identity',
        content: Stack(
          children: [Column()],
        ));
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await setIdentityData();
    });
  }

  Future<void> setIdentityData() async {
    this.isEmailVerified = (await getEmail())['sei'] != null;
    this.isPhoneVerified = (await getPhone())['spi'] != null;

    this.email = (await getEmail())['email'];
    this.phone = (await getPhone())['phone'];


    print(this.isEmailVerified);
    print(this.isPhoneVerified);

    print(this.email);
    print(this.phone);

    print('hi');
  }
}
