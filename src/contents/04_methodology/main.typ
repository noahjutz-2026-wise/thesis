= Methodology


== Overview

// - Which questions should be answered?
// - Which experiments are needed?
// - Which metrics are recorded?
// - How are metrics analyzed?
// - What possible answers exist?

In order to formally ascertain whether a simulation trained model can work in reality, we are going to define some success indicators.

- Accuracy is the fraction of evaluation episodes that end in success. This is the case when the goal is reached within a number of timesteps, without falling into a hole.
- The duration of an episode shall be minimized, in order to solve the maze as quickly as possible.
- Even if an episode doesn't end in success, we are interested in the distance along the path that was achieved.
- @S2R gap?

During training, transfer and evaluation, data is generated from which we can derive these metrics. We configure each experiment with different parameters, mutating one factor at a time to study their effects on these success metrics. The granularity of our independent variables ranges from individual _steps_, which make up _episodes_, which in turn belong to a single _run_. Irrespective of this hierarchy, the wall-clock time will be mapped to each of these discrete variables.

A run can be configured in many ways. Some binary configurations include the choice of algorithm (we will focus on @PPO @ppo and @DreamerV3 @dreamerv3), the environment, which can be either our unity simulation @marble_maze or the real robotics @cyberrunner2, and the model forward pass, which can be exploratory (for training), or inference (for evaluation). Furthermore, we are going to compare the performance between models that have been fine-tuned and those that haven't.


There are many other configurations that can greatly impact the performance of the resulting model after training, however we will focus our efforts on those mentioned above. Hyperparameters shall be left to default values, we will select a single reasonable observation and action space, and reuse a reward function from @cyberrunner.


#figure(caption: [Experiment pipeline for @S2R])[
  #include "figures/experiment.typ"
]

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
