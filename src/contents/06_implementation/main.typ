#import "/src/common/util.typ": ref_requirement

= Implementation

== Requirements

Derived from the data we want to collect, described in @sec_experiments, we will establish a set of requirements for the software stack that will allow us to conduct experiments.

== Requirements <sec:requirements>

The hypothesis formulated in the problem statement can only be tested if the physical system and its simulation are comparable with respect to timing, measurement and interface. The requirements in @tab:requirements are derived from this condition and are grouped by the system to which they apply. Those concerning timing, state estimation and the parameters of the simulation determine the validity of the experimental results and are justified in more detail below the table.

#figure(
  table(
    columns: (auto, 1fr, 1fr),
    align: (center + horizon, left + horizon, left + horizon),
    stroke: (x, y) => if y == 0 {
      (bottom: 0.7pt)
    } else {
      (bottom: 0.3pt + luma(200))
    },
    inset: (x: 6pt, y: 5pt),
    table.header[*ID*][*Requirement*][*Rationale*],

    table.cell(colspan: 3, fill: luma(240))[*Real system*],
    [#ref_requirement("req:timestamps")],
    [Every observation carries a capture timestamp and every action an issue timestamp, both taken from a single shared clock.],
    [System identification; latency as a measured quantity; latency ablation.],
    [#ref_requirement("req:control-frequency")],
    [The control loop runs at a fixed frequency, and the delivery of observations follows a defined policy (latest value wins, bounded queues).],
    [Constant time step; constant and replicable delay; comparability with the baseline.],
    [#ref_requirement("req:state-estimation")],
    [The state estimate (ball position and board angle) can be computed independently of the control loop, including offline from recorded images.],
    [Identical measurement chain for system identification and policy; noise characteristics must be known.],
    [#ref_requirement("req:safety")], [Actuator commands are limited to a range that cannot damage the rig.],
    [Protection of the hardware; reduced supervision.],

    table.cell(colspan: 3, fill: luma(240))[*Simulation*],
    [#ref_requirement("req:geometry")],
    [The simulated board, walls, holes and ball reproduce the measured dimensions of the physical rig, and the measurement uncertainty of each dimension is reported.],
    [Geometric reality gap; traceability of the model.],
    [#ref_requirement("req:ablation")],
    [Observation delay, action delay, drive dynamics and ball-position noise are configurable and can each be switched off individually.],
    [Isolating the contribution of each effect to the reality gap.],
    [#ref_requirement("req:domain-randomization")],
    [Physical parameters are sampled per episode around their nominal values from bounded, seed-controlled distributions.],
    [Domain randomization; physically valid parameter values.],
    [#ref_requirement("req:performance")],
    [The simulation runs substantially faster than real time and yields identical results for identical seed and configuration.],
    [Cost reduction as the premise of the thesis; reproducibility.],

    table.cell(colspan: 3, fill: luma(240))[*Both backends*],
    [#ref_requirement("req:interface")],
    [Both backends provide the same observation, action, reward and termination interface, selectable by configuration.],
    [Zero-shot transfer requires identical spaces.],
    [#ref_requirement("req:logging")],
    [Observation, action, reward and termination flag of every step are recorded with timestamps without altering the timing of the step loop.],
    [Offline analysis; evaluation from logs.],
    [#ref_requirement("req:reproducibility")],
    [Random seed, configuration and code revision are stored with every run.],
    [Reproducibility of results.],
  ),
  caption: [Requirements for the real system, the simulation and both backends.],
) <tab:requirements>

The first group of justifications concerns timing (@req:timestamps, @req:control-frequency). The formulation of reinforcement learning as @MDP:a presupposes a constant interval between decisions, whereas a physical system operates asynchronously and cannot be paused. If the interval varies, the same action has different consequences from the point of view of the policy, and the delay between sensing and acting becomes a random quantity, a setting that requires dedicated treatment /*@bouteillerReinforcementLearningRandom2020*/ @nathRevisitingStateAugmentation2021. A fixed control frequency keeps this delay constant, so that it can be measured once and reproduced in simulation. Timing has also been reported as a dominant cause of the reality gap on this very task @waldemarkUsingReinforcementLearning1995. Timestamps must refer to the instant of capture rather than to the arrival at the estimator, since the two differ by the processing and transport time, and conflating them corrupts every latency derived from them. On a single host with a monotonic clock, latencies are exact differences of timestamps and require no estimation. The same data serve as input for system identification and for the ablation that switches the replication of latency in simulation on and off.

State estimation (@req:state-estimation) is subject to a related consideration. System identification compares measured and simulated trajectories, which is only meaningful if the measurement chain used on the rig is the one that provides the policy with its observations during deployment. The estimator must therefore be usable on its own and on recorded data. Its noise and repeatability are parameters of the simulated sensor model (@req:ablation) and have to be known in order to be modeled.

The requirements on the simulation (@req:geometry, @req:ablation) specify what is to be reproduced, and to what degree of traceability. Geometry is reported with its measurement uncertainty, so that remaining deviations from the rig can be attributed to the model and not to unrecorded measurement error. Recording the origin of each parameter makes explicit which values rest on measurement or identification and which are assumptions. Because each effect in @req:ablation can be disabled individually, its contribution to the transfer result can be isolated in an ablation, which a simulation with fixed, inseparable effects would not permit. Parameters that are sampled during training (@req:domain-randomization) must remain physically valid. Quantities that cannot be negative, such as masses and friction coefficients, therefore require a bounded distribution, for example a truncated Gaussian or a log-normal distribution, since a plain Gaussian can yield unphysical values. Seeding the sampling and recording the sampled values keeps the runs reproducible.

The remaining requirements ensure that experiments can be carried out safely, repeatedly and with identical interfaces on both backends.

== Design

The @S2R pipeline is assembled primarily from existing open-source software rather than from newly developed components. On the @RL side, the pipeline requires an implementation of a policy-training algorithm, a mechanism for logging metrics throughout experiments, as well as managing datasets, trained models and checkpoints. The environment side comprises two interchangeable backends: a simulation that reproduces the labyrinth game, and a physical system together with the control software that actuates it. Both backends are abstracted behind a common, standardized interface, which allows the @RL component to request samples and drive the agent without regard to whether it is interacting with the simulated or the physical environment. Finally, an orchestration layer sits above these components to run experiments under varying parameter configurations and to compare their outcomes systematically.

=== @RL:long Framework

The choice of algorithm implementation warrants careful consideration, as seemingly minor implementation details can lead to substantial differences in performance @shengyi2022the37implementation. Stable-Baselines3 @stable_baselines3 offers well-established reference implementations that emphasize simplicity. Implementations of the same algorithm also differ in practical respects, such as their support for parallelization and their compatibility with the surrounding simulation stack. For instance, RSL-RL and skrl are frequently used together with widely adopted simulation frameworks, and ML-Agents @mlagents ships with its own implementation of @PPO. We ultimately adopted the @PPO and @DreamerV3 implementations provided by RLlib @rllib, owing to its tight integration with the Ray ecosystem. This integration additionally simplifies model checkpointing and transfer, and it provides callbacks for logging metrics during training.

Systematic tracking of experiments, including their configurations, outcomes, and artifacts, is best supported by dedicated tooling. Reproducibility requires recording not only the configuration and random seed of each run but also the exact code revision used. Training metrics should be collected asynchronously, so that logging does not block or otherwise interfere with the training process. In addition, large files such as trained models and raw image observations must be versioned and stored at scale. Existing tools, including Hugging Face Datasets, MLflow, and Data Version Control, each address part of these requirements. We adopted @WandB because it satisfies all of them within a single tool and is simple to use.

=== Simulation

A simulated environment consists of two core components: a simulation engine that approximates the physical interactions of the system, and a renderer that produces visual observations. The choice of engine involves a trade-off between physical fidelity and computational performance, and the ability to run many instances in parallel is an additional consideration. The engine must also support domain randomization through parameterized physics. The renderer, in turn, must reproduce the specifications of the real camera, including its intrinsic parameters and field of view, and must provide realistic lighting and materials that can themselves be randomized.

A range of simulators targeting robotics and @RL research is available, and each makes different trade-offs. Isaac Lab is a highly configurable framework, but its scope and infrastructure exceed the requirements of a single tilting maze. Gazebo is closely coupled to @ROS, which the CyberRunner project employs, but we preferred a more contemporary toolchain that is not dependent on that ecosystem. General-purpose game engines such as Godot and Unreal Engine have likewise been used for @RL. Unity was initially considered on pragmatic grounds, since the existing @RL project @marble_maze provides a working foundation. However, we ultimately chose @MuJoCo @mujoco over Unity. Although MuJoCo's built-in renderer is not designed for high visual fidelity and its collision detection requires concave mazes to be decomposed into convex sub-shapes, it is highly suited to articulated mechanisms with hinges and actuators, and it provides a dedicated sysid package necessary for accurately modeling actuator dynamics.

In addition to selecting a simulation engine, the methodology for generating the environment geometry must be established. While generating meshes directly is computationally faster and can accelerate procedural level generation, the present scope is restricted to a single maze level. Therefore, our primary objectives are high-fidelity dimensional accuracy and implementation simplicity. To achieve this, we eschewed direct mesh generation -- and the insufficiently configurable @SVG importer provided by @marble_maze -- in favor of a #[@CAD]-based approach. We selected build123d @build123d, an open-source @CAD modeling library, due to its Pythonic interface. This programmatic approach facilitates rapid design drafting and the creation of parameterized models, establishing a robust foundation that can be extended in the future to support randomized mazes and curriculum learning. Furthermore, because @MuJoCo requires convex shapes for collision meshes, we integrated @CoACD @coacd to automatically decompose the generated geometry. For auxiliary @CAD operations requiring a graphical user interface, FreeCAD was selected [TODO: confirm inclusion of FreeCAD in the final draft].

=== Robotics

In order to observe the environment and propagate control signals to physical actuators, we need a software stack that handles camera image post processing, object detection, message channels, the control loop, and low-level serial bus communication. We will be mostly reusing the code and hardware setup from @cyberrunner2.

== Components

The structure of the @S2R project can be grouped into training orchestration, control loop, and the backend, which is split into real and simulated. Shared among both backends is any code pertaining to image processing.

#figure(caption: [
  Component diagram of the system architecture.
])[
  #include "figures/arch_components_2.typ"
] <fig_components>

=== Training orchestration

The @S2R pipeline described previously includes training, fine-tuning and evaluating a policy given an experiment configuration.

=== Control Loop

Having a consistent control frequency and latencies is essential for learning. However, real-world systems are asynchronous and have no ability to block physics. This in conjunction with the fact that previous implementations have delegated the responsibility of timing individual step calls to the learning framework or algorithm means we get no guarantees about timing, and cannot evaluate its impact on performance. Furthermore, ignoring these parameters in the simulation could bring about a severe reality gap.

=== Simulated Backend

An optimal simulation behaves identically to the real system. To get close to achieving this, we must accurately depict geometry, visual aspects, latencies, sensor noise and actuator dynamics.

To replicate the geometry, the rig was measured using calipers. Intricate measurements of holes and walls were reused from @cyberrunner2.

(visual aspects)

(sensor latencies)

(sensor noise)

To accurately model the impact an actuation has on the position of the board, we utilize a black-box system identification technique. After modeling the geometry and sensors in @MuJoCo, we collect sample data at various combinations of motor movements and use @MuJoCo's sysid package to minimize the error between simulation and reality.
