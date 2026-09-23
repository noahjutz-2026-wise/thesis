= Methodology

== Overview

- Which questions should be answered?
- Which experiments are needed?
- Which metrics are recorded?
- How are metrics analyzed?
- What possible answers exist?

== Baselines

- Experiments: (@CR, @MM) $times$ (@PPO, @DreamerV3) $times$ (original, modified)

== Naive zero-shot transfer

- Unify observation & reward shapes
- Unify @RL\-Algorithms
- Train N steps, export, inference
- Experiments: (S2S, S2R, R2S, R2R) $times$ (@PPO, @DreamerV3) $times$ (original, modified)

== Improvements

- More realistic simulation environment
- Stochastic delay
- Domain randomization
