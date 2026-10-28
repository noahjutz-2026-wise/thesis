= Implementation

== System Context

The @S2R pipeline is assembled primarily from existing open-source software rather than from newly developed components. On the @RL side, the pipeline requires an implementation of a policy-training algorithm, a mechanism for logging metrics throughout experiments, as well as managing datasets, trained models and checkpoints. The environment side comprises two interchangeable backends: a simulation that reproduces the labyrinth game, and a physical system together with the control software that actuates it. Both backends are abstracted behind a common, standardized interface, which allows the @RL component to request samples and drive the agent without regard to whether it is interacting with the simulated or the physical environment. Finally, an orchestration layer sits above these components to run experiments under varying parameter configurations and to compare their outcomes systematically.

=== @RL:long Framework

The choice of algorithm implementation warrants careful consideration, as seemingly minor implementation details can lead to substantial differences in performance @shengyi2022the37implementation. Stable-Baselines3 @stable_baselines3 offers well-established reference implementations that emphasize simplicity. Implementations of the same algorithm also differ in practical respects, such as their support for parallelization and their compatibility with the surrounding simulation stack. For instance, RSL-RL and skrl are frequently used together with widely adopted simulation frameworks, and ML-Agents @mlagents ships with its own implementation of @PPO. We ultimately adopted the @PPO and @DreamerV3 implementations provided by RLlib @rllib, owing to its tight integration with the Ray ecosystem. This integration additionally simplifies model checkpointing and transfer, and it provides callbacks for logging metrics during training.

Systematic tracking of experiments, including their configurations, outcomes, and artifacts, is best supported by dedicated tooling. Reproducibility requires recording not only the configuration and random seed of each run but also the exact code revision used. Training metrics should be collected asynchronously, so that logging does not block or otherwise interfere with the training process. In addition, large files such as trained models and raw image observations must be versioned and stored at scale. Existing tools, including Hugging Face Datasets, MLflow, and Data Version Control, each address part of these requirements. We adopted @WandB because it satisfies all of them within a single tool and is simple to use.

=== Simulation

A simulated environment consists of two core components: a simulation engine that approximates the physical interactions of the system, and a renderer that produces visual observations. The choice of engine involves a trade-off between physical fidelity and computational performance, and the ability to run many instances in parallel is an additional consideration. The engine must also support domain randomization through parameterized physics. The renderer, in turn, must reproduce the specifications of the real camera, including its intrinsic parameters and field of view, and must provide realistic lighting and materials that can themselves be randomized.

A range of simulators targeting robotics and @RL research is available, and each makes different trade-offs. Isaac Lab is a highly configurable framework, but its scope and infrastructure exceed the requirements of a single tilting maze. Gazebo is closely coupled to ROS, which the CyberRunner project employs, but we preferred a more contemporary toolchain that is not dependent on that ecosystem. General-purpose game engines such as Godot and Unreal Engine have likewise been used for @RL. Unity was initially considered on pragmatic grounds, since the existing @RL project @marble_maze provides a working foundation. However, we ultimately chose @MuJoCo @mujoco over Unity. Although MuJoCo's built-in renderer is not designed for high visual fidelity and its collision detection requires concave mazes to be decomposed into convex sub-shapes, it is highly suited to articulated mechanisms with hinges and actuators, and it provides a dedicated sysid package necessary for accurately modeling actuator dynamics.

In addition to selecting a simulation engine, the methodology for generating the environment geometry must be established. While generating meshes directly is computationally faster and can accelerate procedural level generation, the present scope is restricted to a single maze level. Therefore, our primary objectives are high-fidelity dimensional accuracy and implementation simplicity. To achieve this, we eschewed direct mesh generation -- and the insufficiently configurable SVG importer provided by @marble_maze -- in favor of a #[@CAD]-based approach. We selected build123d @build123d, an open-source @CAD modeling library, due to its Pythonic interface. This programmatic approach facilitates rapid design drafting and the creation of parameterized models, establishing a robust foundation that can be extended in the future to support randomized mazes and curriculum learning. Furthermore, because @MuJoCo requires convex shapes for collision meshes, we integrated @CoACD @coacd to automatically decompose the generated geometry. For auxiliary @CAD operations requiring a graphical user interface, FreeCAD was selected [TODO: confirm inclusion of FreeCAD in the final draft].

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
