import 'package:threebotlogin/helpers/environment.dart';

abstract class EnvConfig {
  Environment environment = Environment.Production;

  String githash = "08d5e68";
  String time = "13:01:35 06.07.2022";
}