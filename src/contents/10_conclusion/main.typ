= Conclusion

- Summary
- Limitations
- Implications
- Future work

== Future Research

- Impact of scaling on sample count and performance
  - *Learner Parallelization:* Using Ray Core
  - *Sim GPU Accel:* Using BRAX, MJX, SKRL, ...
- @RL Methods that were omitted
  - *Curriculum Learning:* Currently a fixed maze is learned, rather than the process of solving a maze. Randomizing in simulation is easy.
  - *Random starts:* initial random ball position
  - *Hyperparameter Optimization*: Using Ray Tune
- @S2R Methods that were omitted
  - *Behavior Cloning*: Fixed policy determined through physical parameters
  - *System Identification:* Ascertain exact friction coefficients, motor acceleration, etc.
  - *R2S2R:* (?)
  - *Different transfers:* R2S, S2S, R2R
