= Methodology


== Experiments

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

A run can be configured in many ways. Some binary configurations include the choice of algorithm (we will focus on @PPO @ppo and @DreamerV3 @dreamerv3), the environment, which can be either our unity simulation @marble_maze or the real robotics @cyberrunner2, and the model forward pass, which can be exploratory (for training), or inference (for evaluation). To study the benefits of domain randomization, we will select different physical parameters from gaussian distributions with varying variances. In particular, we are interested in altering simulated friction coefficients, rigid body masses, motor speeds and velocities, actuator and sensor latencies, and introducing visual inconsistencies. We will vary these parameters on a per-episode basis, because it has been shown to be more effective for @S2R than varying on a per-run basis [CITATION NEEDED].

There are many other configurations that can greatly impact the performance of the resulting model after training, however we will focus our efforts on those mentioned above. Hyperparameters shall be left to default values, and our step budget will be identical for all experiments. Seeds will be selected randomly. We will select a single reasonable observation and action space, and reuse the reward function from @cyberrunner. We are not going to look into the impacts of prioritized sampling, sample augmenting or parallelization on policy convergence speed.

We will collect raw data that is generated on each step, episode or policy update. Of particular interest are observations, which describe the state of the environment and contain all the information we need to determine the performance of a policy. When compared with the subsequent rewards, the efficacy of the reward function can be determined. The interaction between observations and actions can shine light on the dynamics and whether they are accurately learned by the model. Aside from this, algorithm metrics such as loss and entropy can be introspected to determine how much the behavior changes as more policy updates occur.

== Transfer

Returning to the central theme of this work, namely the transfer of models across environments, it is useful to first consider the general methodological procedure. In seeking to offload sample collection to a simulated environment, the conventional approach consists of training a model in simulation until it works reasonably well, subsequently fine-tuning it with data collected in the real world, and finally evaluating its performance. @fig_pipeline shows our experiment pipeline for @S2R.

This reference pipeline can be decomposed and reconfigured to serve different experimental objectives. To establish non-transfer baselines, the fine-tuning step may be omitted. To assess the performance of the simulated model in a more tractable setting, the model may be transferred to a different simulation rather than to the real world (sim-to-sim). Similarly, to iteratively improve the fidelity of the simulation, the order of the environments may be reversed (real-to-sim).

#figure(caption: [
  The @S2R pipeline, exemplifying the research procedure. A set of parameters is defined for each experiment. A model is trained in simulation, fine-tuned in reality and finally evaluated in reality. Data is collected at each step of the way.
])[
  #include "figures/experiment.typ"
] <fig_pipeline>

== Replicating physical parameters

Modeling a realistic simulation of a robotics control tasks requires intricate knowledge of the dymanics, and therefore physical properties, of the system. We will evaluate which properties must be taken into account, how they can be approximated, and how we can gather the physical values that best represent the labyrinth game.

The physical setup consists of a rectangular wooden playing area mounted on a gimbal rig with two rotating hinges, providing the required degrees of freedom to rotate. For each axis, a rope is attached on two opposing sides of the board and wound along an orthogonal rod. When a player or motor rotates the rod using a knob, the friction between the rod and rope causes the rope to move and pull on one end of the surface, causing it to tilt. This in turn causes a spherical metal ball on the playing area to begin rolling downwards, potentially bumping into walls or falling into a hole.

The system consists of three coupled subsystems: the gimbal-mounted board, the rope transmission, and the rolling ball. Simulation of the rope-pulley transmission is costly and requires parameters that are hard to measure (e.g. rope elasticity, pulley friction, capstan slip). We therefore replace it with a simpler model that skips the rope entirely, in which turning the rod by a certain angle tilts the board by a proportional amount. In reality, the rope is not perfectly tight: it stretches, slips, and has some slack, so the board reacts late, not at all to small movements, and not always by the same amount. We capture this with three simple effects: a delay and sluggishness in how fast the board follows the motor, a dead zone where the rod turns without moving the board (the slack), and a small random variation in the rod-to-board ratio. The exact values are measured on the real rig and randomized during training, so the controller learns to cope with an imperfect rope.

To make this simplified model match the real game, we need to measure a small set of physical quantities. For the board, the main quantities are its mass and moment of inertia about the two hinge axes, the offset of the hinges from the board’s center of mass, which affects how the board responds to the weight of the ball, and the maximum tilt angle permitted by the frame. For the ball and its interaction with the board, we need the rolling resistance coefficient, which determines how quickly the ball decelerates on a flat surface, and the coefficient of restitution of the walls, which determines how much speed is retained in a collision. The rolling resistance can be estimated by letting the ball roll across the level board and fitting the deceleration from camera footage, and the coefficient of restitution by comparing the ball’s speed before and after impact with a wall.

The rope drive requires the most careful measurement, as it deviates most from the ideal model. We first need the rod radius and the distance from each hinge to the rope attachment point, since their ratio gives the nominal transmission ratio between rod angle and board angle. We then compare this value with the real behavior in a sweep test, in which the rod is turned slowly back and forth while the board angle is recorded, for example with a tilt sensor or by tracking markers on the board with the camera. The resulting hysteresis loop reveals the size of the dead zone, the difference in transmission ratio between directions, and the drift of the zero position over time. Repeating the test at different speeds and with the ball at different positions indicates how strongly the rope’s behavior depends on load. A step test, in which the motor is suddenly commanded to a new angle, yields the delay and time constant of the board’s response. Together, these measurements provide the nominal values around which the rope parameters are randomized during training.

For the sensors, the camera’s resolution, frame rate, and latency between image capture and availability of the ball position determine the quality of the state information. We further need a calibration that maps pixel coordinates to board coordinates, using known reference points such as the board corners, and an estimate of the noise in the detected ball position. For the actuators, we need each motor’s maximum speed and torque, its gear ratio, the encoder resolution, and any backlash in the connection between motor and rod, which adds to the dead zone identified above.

== Naive zero-shot transfer

- Unify observation & reward shapes
- Unify @RL\-Algorithms
- Train N steps, export, inference
- Experiments: (S2S, S2R, R2S, R2R) $times$ (@PPO, @DreamerV3) $times$ (original, modified)

== Improvements

- More realistic simulation environment
- Stochastic delay
- Domain randomization
