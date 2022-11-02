import 'package:threebotlogin/core/events/classes/event.classes.dart';
import 'package:threebotlogin/core/events/services/events.service.dart';
import 'package:threebotlogin/views/recover/recover.dialogs.dart';

Future<void> initializeEventListeners() async {
  Events().onEvent(RecoveredEvent().runtimeType, (RecoveredEvent event) async {
    await Future.delayed(const Duration(seconds: 1));
    showSuccessfullyRecovered();
  });
}
