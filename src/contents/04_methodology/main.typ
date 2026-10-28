= Methodology


== Experiments

// - Which questions should be answered?
// - Which experiments are needed?
// - Which metrics are recorded?
// - How are metrics analyzed?
// - What possible answers exist?

In order to formally ascertain whether a simulation trained model can work in reality, we are going to define some success indicators.

- In terms of _performance_, accuracy is the fraction of evaluation episodes that end in success. This is the case when the goal is reached within a number of timesteps, without falling into a hole. Even if an episode doesn't end in success, we are interested in the distance along the path that was achieved. The duration of an episode shall be minimized, in order to solve the maze as quickly as possible. @S2R gap?
- To measure how _robust_ a policy is to perturbations in sensing and actuation, we are going to evaluate its performance under conditions that quantitatively differ from its training environment.
- The practicality of our approach is limited by its _cost_, in terms of sample efficiency and compute power.
- Some metrics can explain to us why the approach might not work. Perhaps there is a discrepancy between actuation and real-world impact, or some delay.

During training, transfer and evaluation, data is generated from which we can derive these metrics. We configure each experiment with different parameters, mutating one factor at a time to study their effects on these success metrics. The granularity of our independent variables ranges from individual _steps_, which make up _episodes_, which in turn belong to a single _run_. Irrespective of this hierarchy, the wall-clock time will be mapped to each of these discrete variables.

A run can be configured in many ways. Some binary configurations include the choice of algorithm (we will focus on @PPO @ppo and @DreamerV3 @dreamerv3), the environment, which can be either our unity simulation @marble_maze or the real robotics @cyberrunner2, and the model forward pass, which can be exploratory (for training), or inference (for evaluation). To study the benefits of domain randomization, we will select different physical parameters from gaussian distributions with varying variances. In particular, we are interested in altering simulated friction coefficients, rigid body masses, motor speeds and velocities, actuator and sensor latencies, and introducing visual inconsistencies. We will vary these parameters on a per-episode basis, because it has been shown to be more effective for @S2R than varying on a per-run basis [CITATION NEEDED].

There are many other configurations that can greatly impact the performance of the resulting model after training, however we will focus our efforts on those mentioned above. Hyperparameters shall be left to default values, and our step budget will be identical for all experiments. Seeds will be selected randomly. We will select a single reasonable observation and action space, and reuse the reward function from @cyberrunner. We are not going to look into the impacts of prioritized sampling, sample augmenting or parallelization on policy convergence speed.

We will collect raw data that is generated on each step, episode or policy update. Of particular interest are observations, which describe the state of the environment and contain all the information we need to determine the performance of a policy. When compared with the subsequent rewards, the efficacy of the reward function can be determined. The interaction between observations and actions can shine light on the dynamics and whether they are accurately learned by the model. Aside from this, algorithm metrics such as loss and entropy can be introspected to determine how much the behavior changes as more policy updates occur.

- *@S2R Gap measurements:*
  - https://consensus.app/search/sim-to-real-transfer-metrics/OUSO2zp8TkSDDfWzzJ4w8A/?utm_source=share&utm_medium=clipboard

== Simulation

Modeling a realistic simulation of a robotics control tasks requires intricate knowledge of the dymanics, and therefore physical properties, of the system. We will evaluate which properties must be taken into account, how they can be approximated, and how we can gather the physical values that best represent the labyrinth game.

The physical setup consists of a rectangular wooden playing area mounted on a gimbal rig with two rotating hinges, providing the required degrees of freedom to rotate. For each axis, a rope is attached on two opposing sides of the board and wound along an orthogonal rod. When a player or motor rotates the rod using a knob, the friction between the rod and rope causes the rope to move and pull on one end of the surface, causing it to tilt. This in turn causes a spherical metal ball on the playing area to begin rolling downwards, potentially bumping into walls or falling into a hole.

The system consists of three coupled subsystems: the gimbal-mounted board, the rope transmission, and the rolling ball. Simulation of the rope-pulley transmission is costly and requires parameters that are hard to measure (e.g. rope elasticity, pulley friction, capstan slip). We therefore replace it with a simpler model that skips the rope entirely, in which turning the rod by a certain angle tilts the board by a proportional amount. In reality, the rope is not perfectly tight: it stretches, slips, and has some slack, so the board reacts late, not at all to small movements, and not always by the same amount. We capture this with three simple effects: a delay and sluggishness in how fast the board follows the motor, a dead zone where the rod turns without moving the board (the slack), and a small random variation in the rod-to-board ratio. The exact values are measured on the real rig and randomized during training, so the controller learns to cope with an imperfect rope.

To make the simplified model match the real game, we treat the dynamics as a black box and measure only how control signals affect the ball position and the board angle.

For the drive, we apply the same inputs to the real game and the simulator: a slow back-and-forth sweep of the rod and a sudden step to a new angle. We record the board angle in both cases and adjust certain simulator parameters heuristically, such as the dead zone, the delay, and the time constant, until similar inputs lead to similar outputs. Repeating the tests at different speeds and with the ball at different positions shows how strongly the behavior depends on load. The resulting values are the nominal values around which the drive parameters are randomized during training.

For the sensors, the camera’s resolution, frame rate, and latency between image capture and availability of the ball position determine the quality of the state information, along with an estimate of the noise in the detected ball position.

#figure(
  caption: [Latencies occured during sensing and actuation on real-world systems. Based on @nathRevisitingStateAugmentation2021],
)[
  #include "figures/latency.typ"
]

== Transfer

Returning to the central theme of this work, namely the transfer of models across environments, it is useful to first consider the general methodological procedure. In seeking to offload sample collection to a simulated environment, the conventional approach consists of training a model in simulation until it works reasonably well, subsequently fine-tuning it with data collected in the real world, and finally evaluating its performance. @fig_pipeline shows our experiment pipeline for @S2R.

This reference pipeline can be decomposed and reconfigured to serve different experimental objectives. To establish non-transfer baselines, the fine-tuning step may be omitted. To assess the performance of the simulated model in a more tractable setting, the model may be transferred to a different simulation rather than to the real world (sim-to-sim). Similarly, to iteratively improve the fidelity of the simulation, the order of the environments may be reversed (real-to-sim).

#figure(caption: [
  The @S2R pipeline, exemplifying the research procedure. A set of parameters is defined for each experiment. A model is trained in simulation, fine-tuned in reality and finally evaluated in reality. Data is collected at each step of the way.
])[
  #include "figures/experiment.typ"
] <fig_pipeline>

Before we get into more advanced optimization techniques, we need to ensure that a naive zero-shot @S2R transfer works. The requisites for this include that both the simulated and real environment share some properties: They must have identical state and action spaces and utilize compatible model architectures.
