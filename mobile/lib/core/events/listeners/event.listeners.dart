import 'package:flutter/material.dart';
import 'package:threebotlogin/core/events/classes/event.classes.dart';
import 'package:threebotlogin/core/events/services/events.service.dart';
import 'package:threebotlogin/core/storage/globals.storage.dart';
import 'package:threebotlogin/core/yggdrasil/classes/yggdrasil.classes.dart';
import 'package:threebotlogin/views/home/views/home.view.dart';
import 'package:threebotlogin/views/recover/dialogs/recover.dialogs.dart';

Future<void> initializeEventListeners() async {
  Events().onEvent(RecoveredEvent().runtimeType, (RecoveredEvent event) async {
    await Future.delayed(const Duration(milliseconds: 100));
    showSuccessfullyRecovered();
  });

  Events().onEvent(GoHomeEvent().runtimeType, (GoHomeEvent event) async {
    await Navigator.push(Globals().globalBuildContext, MaterialPageRoute(builder: (context) => HomeScreen()));
  });

  Events().onEvent(CloseVpnEvent().runtimeType, (CloseVpnEvent event) async {
    VpnState vpn = Globals().vpnState;
    if (vpn.vpnConnected) Globals().vpnState.plugin.stopVpn();
  });
}
