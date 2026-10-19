= Methodology


== Experiment Pipeline

// - Which questions should be answered?
// - Which experiments are needed?
// - Which metrics are recorded?
// - How are metrics analyzed?
// - What possible answers exist?

In order to formally ascertain whether a simulation trained model can work in reality, we are going to define some success indicators.

- In therms of _performance_, accuracy is the fraction of evaluation episodes that end in success. This is the case when the goal is reached within a number of timesteps, without falling into a hole. Even if an episode doesn't end in success, we are interested in the distance along the path that was achieved. The duration of an episode shall be minimized, in order to solve the maze as quickly as possible. @S2R gap?
- To measure how _robust_ a policy is to perturbations in sensing and actuation, we are going to evaluate its performance under conditions that quantitatively differ from its training environment.
- The practicality of our approach is limited by its _cost_, in terms of sample efficiency and compute power.
- Some metrics can explain to us why the approach might not work. Perhaps there is a discrepancy between actuation and real-world impact, or some delay.

During training, transfer and evaluation, data is generated from which we can derive these metrics. We configure each experiment with different parameters, mutating one factor at a time to study their effects on these success metrics. The granularity of our independent variables ranges from individual _steps_, which make up _episodes_, which in turn belong to a single _run_. Irrespective of this hierarchy, the wall-clock time will be mapped to each of these discrete variables.

A run can be configured in many ways. Some binary configurations include the choice of algorithm (we will focus on @PPO @ppo and @DreamerV3 @dreamerv3), the environment, which can be either our unity simulation @marble_maze or the real robotics @cyberrunner2, and the model forward pass, which can be exploratory (for training), or inference (for evaluation). Furthermore, we are going to compare the performance between models that have been fine-tuned and those that haven't. To study the benefits of domain randomization, we will select different physical parameters from gaussian distributions with varying variances. In particular, we are interested in altering simulated friction coefficients, rigid body masses, motor speeds and velocities, actuator and sensor latencies, and introducing visual inconsistencies.

There are many other configurations that can greatly impact the performance of the resulting model after training, however we will focus our efforts on those mentioned above. Hyperparameters shall be left to default values, and our step budget will be identical for all experiments. Seeds will be selected randomly. We will select a single reasonable observation and action space, and reuse the reward function from @cyberrunner. We are not going to look into the impacts of prioritized sampling, sample augmenting or parallelization on policy convergence speed.

We will collect raw data that is generated on each step, episode or policy update. Of particular interest are observations, which describe the state of the environment and contain all the information we need to determine the performance of a policy. When compared with the subsequent rewards, the efficacy of the reward function can be determined. The interaction between observations and actions can shine light on the dynamics and whether they are accurately learned by the model. Aside from this, algorithm metrics such as loss and entropy can be introspected to determine how much the behavior changes as more policy updates occur.

@fig_pipeline shows our experiment pipeline for @S2R.

#figure(caption: [Experiment pipeline for @S2R])[
  #include "figures/experiment.typ"
] <fig_pipeline>

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
