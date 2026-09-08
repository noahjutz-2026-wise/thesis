= Implementierung

== Architektur

- Systemkontext
  - Hardware
- Bausteinsicht

== dreamerv3-deploy

- Reproduzierbares plug-and-play @DreamerV3 deployment
- Verwendet @Ray in einem Container
- Mit @WandB logging
- Networking für Kommunikation mit Environment
- Exportieren und importieren von Modellen

== cyberrunner-3d-models

- Servobasiertes Design
- Robuste Nachladevorrichtung

== cyberrunner-gymnasium

- Fork von @CR
- Decouple @CR from @DreamerV3
- Gymnasium environment erstellen
- Latenz und Clock rate fixieren

== marblemaze-gymnasium

- Decouple @MarbleMaze from @PPO
- Gymnasium environment erstellen
