= Implementierung

== Architektur

- Systemkontext
  - Hardware
- Bausteinsicht

== #[@DreamerV3]-deploy

- Reproduzierbares plug-and-play @DreamerV3 deployment
- Verwendet @Ray in einem Container
- Mit @WandB logging
- Networking für Kommunikation mit Environment
- Exportieren und importieren von Modellen

== #[@CR]-3d-models

- Servobasiertes Design
- Robuste Nachladevorrichtung

== #[@CR]-gymnasium

- Fork von @CR
- Decouple @CR from @DreamerV3
- Gymnasium environment erstellen
- Latenz und Clock rate fixieren

== #[@MarbleMaze]-gymnasium

- Decouple @MarbleMaze from @PPO
- Gymnasium environment erstellen
