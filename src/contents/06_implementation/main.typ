= Implementation

== Requirements

Derived from the data we want to collect, described in @sec_experiments, we will establish a set of requirements for the software stack that will allow us to conduct experiments.

#text(size: 8pt)[
  Real system
  - R1 Timing data [~]
    - what
      - capture timestamp for every observation and issue timestamp for every action, per discrete step, on one shared clock [+]
      - shared clock: single host, monotonic time base [+]
    - why
      - system identification needs input/output pairs with known timing
      - quantify how replicating latency in simulation affects performance (ablation)
      - latency = difference of timestamps, not an estimate [+]
    - check
      - per-stage latency distribution (6.1)
  - R2 Fixed control rate [~]
    - what
      - fixed frequency (target: close to the ~55 Hz of [Bi+25])
      - defined delivery policy [+]: latest-value-wins, bounded queues, no silent backlog
    - why
      - the MDP assumes a constant time step
      - constant step makes the delay constant, so it can be modelled and replicated in simulation
      - stale queued observations add hidden latency
      - comparability with the baseline
    - check
      - achieved frequency and jitter, missed-cycle count (6.1)
  - R3 Isolated, characterized state estimation [+]
    - what
      - pose estimate (ball position, board angle) callable on its own, including offline on recorded images
      - calibration (fisheye undistortion) without proprietary tooling
    - why
      - the same measurement chain must feed sysid and the policy
      - measurement noise is a simulation parameter and must be known
      - reproducibility without MATLAB
    - check
      - noise and repeatability on a static scene, reprojection error (6.1)
  - R4 Non-intrusive logging [+]
    - what
      - raw data (timestamps, actions, observations, ideally images) recorded without blocking the control loop
    - why
      - replay, offline analysis, evaluation from logs
    - check
      - loop jitter unchanged with logging on
  - R5 Safe unattended operation [+]
    - what
      - actuator limits
      - defined behaviour on sensor loss or ball-out-of-play
    - why
      - protects the rig
      - reduces human supervision (a cost driver named in 1.2)
    - check
      - stated, tested once
  - R6 Exchangeable components (secondary) [+]
    - what
      - transport, estimator and actuator behind narrow interfaces
    - why
      - transport swap (iceoryx2 trial) and estimator iteration without touching the rest
  Simulation
  - R7 Physical fidelity [~]
    - what
      - geometry from measurement
      - masses and friction from measurement or identification
      - each parameter tagged measured / identified / assumed [+]
      - "medium fidelity" defined as the set of effects modelled (geometry, drive dynamics, latency, sensor noise) [+]
    - why
      - defines the fidelity level named in the hypothesis
      - transparency about which values are known
    - check
      - held-out trajectory error vs. rig (6.2)
  - R8 Sensors and actuators [~]
    - what
      - configurable observation delay, action delay
      - drive dynamics (time constant, dead zone, gain variation)
      - ball-position noise
      - each effect individually switchable [+]
    - why
      - timing and noise are the dominant gap sources reported in [Wal95]
      - switchability is what makes the ablations possible
    - check
      - on/off ablation runs (6.5)
  - R9 Domain randomization [~]
    - what
      - per-episode sampling around identified nominal values
      - distribution family and ranges configurable and seed-controlled
      - positive-only parameters need a bounded family (truncated Gaussian or log-normal) [+]
    - why
      - S2R technique
      - tests whether robustness to parameter error helps transfer
    - check
      - sampled ranges logged per episode
  - R10 Speed and determinism [+]
    - what
      - simulation substantially faster than real time
      - identical results for identical seed and config
      - physics step consistent with the control period
    - why
      - cost reduction is the premise of the thesis
      - reproducibility
    - check
      - steps/s vs. real time, repeat-run comparison
  - Both backends
  - R11 Common interface [+]
    - what
      - identical observation, action, reward and termination contract, selectable by configuration
    - why
      - zero-shot transfer requires identical spaces
      - analysis code stays backend-agnostic
    - check
      - interface test run against both backends
  - R12 Reproducible runs [+]
    - what
      - seed, config and code revision stored with every run
      - open toolchain
      - pinned dependencies
    - why
      - reproducibility is a stated contribution
  - Notes on the open points
  - "Facilitate learning, ...?" (R2)
    - the defensible reasons are the three in R2's why: constant step keeps the MDP well defined, constant delay can be modelled, queued stale data adds invisible latency
    - "facilitate learning" alone is too vague to defend
  - QoS (R2)
    - the term comes from DDS/ROS and your layer is ZeroMQ-based, so it is ambiguous
    - replace it with the concrete policy you implemented (drop behaviour, queue depth) and define it in one sentence
  - Timing (R1)
    - say "capture time" explicitly
    - arrival time at the estimator is not the observation time, and mixing them corrupts sysid
  - Gaussian (R9)
    - Gaussian sampling can produce negative masses or friction coefficients, hence the bounded family
  - Order of reading
    - R1 to R3 and R7 to R8 are load-bearing for the hypothesis
    - R4 to R6 and R10 to R12 are support requirements, one or two lines each in the final text
  - Each check maps to a Results subsection, so the requirements give you the skeleton of 6.1 and 6.2
]
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
