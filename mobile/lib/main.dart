import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:threebotlogin/core/events/listeners/event.listeners.dart';
import 'package:threebotlogin/core/storage/core.storage.dart';
import 'package:threebotlogin/core/storage/globals.storage.dart';
import 'package:threebotlogin/views/landing.view.dart';
import 'package:google_fonts/google_fonts.dart';

import 'views/connection/connection.view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  bool initDone = await getInitialized();
  String? doubleName = await getUsername();

  bool isRegistered = doubleName != null;

  await initializeEventListeners();

  runApp(MainApp(initDone: initDone, registered: isRegistered));
}

class MainApp extends StatelessWidget {
  MainApp({required this.initDone, required this.registered});

  final bool initDone;
  final bool registered;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        tabBarTheme: TabBarTheme(labelStyle: GoogleFonts.lato(), unselectedLabelStyle: GoogleFonts.lato()),
        appBarTheme: AppBarTheme(color: Colors.white),
      ),
      home: ConnectionScreen(),
    );
  }
}
