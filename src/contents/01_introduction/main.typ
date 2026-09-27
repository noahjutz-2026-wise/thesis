= Introduction

== Motivation

@DRL:both has proven to be applicable in various robotics tasks, including complex non-linear applications, and remains a promising field of study for all matter of control tasks. The trial-and-error learning method allows for developing novel solutions to problems without explicit direction given by the researcher due to its reward-based exploratory approach. By utilizing Deep @NN:pl for encoding behavior and world models, large continuous state spaces (e.g. camera images) and action spaces (e.g. motor target velocity) become tractable.

Training real-world systems entails new challenges that are subject to current research. Parallelizing learning requires purchasing the physical systems required for agents and environments, which is often prohibitively expensive. Manual supervision of failure-prone setups, maintenance of assemblies subject to constant wear and storage contribute to the costs of conducting research on real-world physical systems. The physical constraints of the real-world environment that agents act in impose a lower bound on the required wall-time for collecting experience. For example, resetting an environment might require waiting for the motors in a system to revert to their original position. Finally, equipment that is being used for training cannot be otherwise utilized in the mean time, increasing downtime. In summary, collecting experience in real-world experiments can become prohibitively expensive.

To address this issue, a multitude of solutions have been proposed, which can be categorized into those that aim to improve sample efficiency, and those that aim to lower the cost of generating samples. As for the former, @cyberrunner2 employs data augmentation to a symmetric marble game by mirroring camera observations, thereby increasing success rates. In this thesis, we want to focus on the latter case. By generating trajectories for training a model in simulation and transferring said model to the real world, we hope to reduce the amount of required training time on the physical system. This strategy, known as @S2R, has seen a stark increase in research activity recently, particularly in the fields of locomotion and navigation.

@S2R comes with its own set of hurdles to overcome.

Solutions
- sample efficiency
  - Reward shaping
  - data augmenting
  - selective sampling
- cheaper samples
  - sim2real

== Problem formulation

Throughout this work, we are going to restrict our attention to a particular commercialy available marble maze game known as the BRIO Labyrinth. The goal is to navigate a marble through a labyrinth on a perforated surface. Players use two rotating knobs, which together control the rotation of the surface around two perpendicular axes. The resulting composed surface rotation determines the direction that ball gravitates toward.

Problems
- Reproducing @CR proves difficult
- Collecting experience is slow and unreliable
- Safety concerns

Solutions
- @S2R
- Reward shaping
- (Stochastic) Latency-aware learning

== Related work

Solving the labyrinth game at hand through the use of @RL has been the subject of rigorous experimentation.

- @jhaLearningTasksComplex: @S2R Circular Maze
- @otaDataEfficientLearningComplex2021: @S2R Circular Maze
- @baarSimtoRealTransferLearning2019: @S2R Circular Maze
- Contributions of this work
- Differences to this work
