enum Environment { Staging, Production, Testing, Local }

abstract class EnvConfig {
  Environment environment = Environment.Local;

  String gitHash = "";
  String time = "";
}