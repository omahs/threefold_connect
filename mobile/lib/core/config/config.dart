import 'package:threebotlogin/core/config/enums/config.enums.dart';

abstract class EnvConfig {
  Environment environment = Environment.Staging;

  String gitHash = "fc95409";
  String time = "16:28:58 21.11.2022";
}