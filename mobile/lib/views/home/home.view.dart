import 'package:flutter/material.dart';
import 'package:threebotlogin/core/auth/pin/views/auth.view.dart';
import 'package:threebotlogin/core/components/dividers/box.dividers.dart';
import 'package:threebotlogin/core/components/tabs/tabs.core.dart';
import 'package:threebotlogin/core/storage/globals.storage.dart';
import 'package:threebotlogin/views/connection/connection.widgets.dart';
import 'package:threebotlogin/views/home/home.widgets.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen();

  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  _HomeScreenState();

  @override
  Widget build(BuildContext context) {
    Globals().globalBuildContext = context;
    return LayoutDrawer(
      titleText: 'Home',
      content: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              logo,
              kSizedBoxSm,
              registeredLogo(),
              kSizedBoxSm,
              introText,
            ]),
      ),
    );
  }

  Widget registeredLogo() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.5,
      height: MediaQuery.of(context).size.width * 0.5,
      decoration: BoxDecoration(
        image: DecorationImage(fit: BoxFit.fill, image: AssetImage('assets/threefold_registered.png')),
      ),
    );
  }
}
