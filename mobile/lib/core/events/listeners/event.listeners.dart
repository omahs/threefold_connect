import 'package:flutter/material.dart';
import 'package:threebotlogin/core/events/classes/event.classes.dart';
import 'package:threebotlogin/core/events/services/events.service.dart';
import 'package:threebotlogin/core/storage/globals.storage.dart';
import 'package:threebotlogin/views/home/home.view.dart';
import 'package:threebotlogin/views/recover/dialogs/recover.dialogs.dart';

Future<void> initializeEventListeners() async {
  Events().onEvent(RecoveredEvent().runtimeType, (RecoveredEvent event) async {
    await Future.delayed(const Duration(seconds: 1));
    showSuccessfullyRecovered();
  });

  Events().onEvent(GoHomeEvent().runtimeType, (GoHomeEvent event) async {
    await Navigator.push(Globals().globalBuildContext, MaterialPageRoute(builder: (context) => HomeScreen()));
  });
}
