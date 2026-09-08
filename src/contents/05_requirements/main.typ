= Anforderungen und Design

== Probleme

- @CR Baseline
  - Hardware nicht robust (beweis notwendig?)
  - Gleiche Algorithmen sind nur bei gleicher Implementierung vergleichbar
  - Latenz und Clock-Rate werden nicht berücksichtigt
- @MarbleMaze Baseline
  - Unterschiedliche #[@RL]-Algorithmen (@PPO, @DreamerV3) sind nicht vergleichbar
  - Unterschiedliche Action Spaces und Observations sind nicht vergleichbar
- @S2R
  - @MarbleMaze muss Modell exportieren
  - #[@CR] muss Modell importieren, um es zu evaluieren
  - Physikalische Eigenschaften

== Anforderungen

=== Simulierte Umgebung

- @MarbleMaze + Gymnasium

=== Physisches System

- @CR + Gymnasium

=== Transfer
