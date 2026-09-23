= Methodik

- Vorgehen, um Forschungsfrage zu beantworten

+ Gemeinsame Architektur schaffen
  - Gymnasium Environment (Observation & Reward)
  - @DreamerV3 deployment (@Ray)
  - Modularisierung durch @IPC
  - Konsistente Clock Rate & Latenz
  - Hardware- & #[@RL]-Metrics loggen (@WandB)
+ @CR für Baseline anpassen
  - Hardware-Umbau für robuste lange tests
+ @CR Experimente
  - Baseline-CR, vgl. mit @cyberrunner
  - Baseline-Servo mit umgebauter Hardware
+ @MM anpassen
  - @MLAgents Schnittstelle für beliebige RL-Algorithmen
+ @MM experimente
  - Baseline-MM-PPO
  - Baseline-MM-Dreamer
+ @S2R
  - Baseline-MM-Dreamer Modell auf @CR evaluieren
