import 'package:flutter/material.dart';
import 'package:threebotlogin/core/components/tabs/tabs.core.dart';
import 'package:threebotlogin/views/recover/recover.dialogs.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen();

  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  _HomeScreenState();

  @override
  Widget build(BuildContext context) {
    return LayoutDrawer(
      titleText: 'Test',
      content: Container(
        child: ElevatedButton(
          onPressed: () async {
            await showSuccessfullyRecovered();
          },
          child: Text('a'),
        ),
      ),
    );
  }
}
