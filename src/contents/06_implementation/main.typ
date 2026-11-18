#let todo-fig(body) = rect(
  width: 100%,
  inset: 1em,
  stroke: (dash: "dashed"),
)[*TODO figure:* #body]

= System Design

This chapter describes the software developed to test the hypothesis formulated in the problem statement. Testing it requires a physical labyrinth and a simulated counterpart that are comparable with respect to their dynamics, observations and learning algorithm. The chapter first gives an overview of the components of the system and the dependencies between them (@sec:architecture). It then describes each component in the order in which its artifacts are produced: the real backend, which senses and actuates the physical labyrinth (@sec:real); the MuJoCo backend, which represents the labyrinth in simulation (@sec:sim); the environments that define the learning task on top of both (@sec:task); and the runtimes that train policies in them (@sec:runtime).

== Architectural Overview <sec:architecture>

The system is organized along two axes. The first is the domain, real or simulated. The second is the layer within a domain, of which there are three. A _backend_ provides access to the labyrinth itself, by sensing and actuating the rig in the real domain and by representing its geometry and dynamics in the simulated one. An _environment_ defines the learning task on top of a backend, in terms of observations, actions, rewards, and terminations. A _runtime_ trains policies in an environment. This yields six components, listed in @tbl:components together with what each depends on and the artifact it produces. Their relationships are shown in @fig:components.

#figure(
  table(
    columns: (auto, 1fr, 1fr),
    align: (start + horizon, start + horizon, start + horizon),
    table.header[*Component*][*Depends on*][*Artifact*],
    [Real backend], [Camera calibration and markers, MPU-6050 microcontroller, ZeroMQ], [Container image],
    [MuJoCo backend], [build123d maze model, MuJoCo system identification], [MuJoCo XML model],
    [Real environment], [Real backend], [Gymnasium environment],
    [mjlab environment], [MuJoCo backend, mjlab], [mjlab task],
    [Real runtime], [RLlib, Weights & Biases], [Trained policy module],
    [mjlab runtime], [mjlab, rsl-rl, Weights & Biases], [Trained policy],
  ),
  caption: [Components of the system, their dependencies, and the artifacts they produce.],
) <tbl:components>

#figure(
  todo-fig[Dependency diagram of the six components, arranged in a grid of real and simulated domain versus backend, environment and runtime layer, with arrows for dependencies and labeled artifacts on the connections between layers.],
  caption: [Overview of the components of the system.],
) <fig:components>

Two links connect the domains. The first runs from the real to the simulated domain: recordings taken on the rig by the real backend are used to identify the parameters of the MuJoCo model (@sec:sim-sysid). The second runs through the environments. Observations, actions, rewards and terminations must be defined identically in both, and since only what can be sensed and actuated on the physical rig can be defined at all, this common definition is constrained by the real domain rather than by what is convenient to simulate (@sec:task). A policy trained in either domain can therefore be executed in the other.

== Real Backend <sec:real>

The real backend is the software that senses and actuates the physical labyrinth. Its main functional component is a computer vision pipeline that estimates the state of the ball and the board from camera images, supplemented by an inertial sensor and a motor interface. It exposes these sensors and actuators to client programs, and it does not itself define a learning task.

The backend follows the same goals as the nodes of the CyberRunner project @cyberrunner @cyberrunner2, and adopts its hardware setup and its architecture of asynchronous nodes that exchange messages. It is, however, an independent project with a more limited scope, and it is not derived from the CyberRunner codebase. The experience with the original that led to this decision is summarized in @sec:real-prior. The requirements the backend meets are given in @tbl:req-real.

#figure(
  caption: [Requirements for the real backend.],
)[
  #include "tables/requirements-real.typ"
] <tbl:req-real>

=== Architecture <sec:real-arch>

The backend consists of nodes that each run in their own process and exchange messages through a @PubSub. The nodes are:

- `camera`: acquires frames from the camera and publishes them with a capture timestamp.
- `vision`: estimates the state of the ball and the board from frames (@sec:real-cv).
- `mpu`: reads an MPU-6050 inertial measurement unit attached to the board through an Arduino Nano microcontroller, and publishes timestamped measurements.
- `actuator`: forwards commands to the motors and restricts their range of motion, so that the rig cannot be driven into damaging positions (@req:real_safety).
- `broker`: relays messages between all other nodes.

Further clients can attach to the same message bus without being part of this set. The backend ships a debugger that visualizes the state estimates, a manual controller, and clients that drive the actuators and record the response for system identification (@sec:sim-sysid). The clock rate of any control loop is determined by the client that uses the backend, not by the backend.

Messages are passed using @ZMQ, chosen for its simplicity and its light weight. In a real-time setting its default queueing behavior is a pitfall: with the conflation option set, queues become unbounded unless drained, messages sent to a full buffer are silently discarded, and many publishers can overload a subscriber. Buffer sizes are therefore limited, subscribers drain their sockets, and sensor messages carry timestamps so that stale data can be identified and discarded.

The backend is a Python project with locked dependency versions, packaged as a container image (@req:real_reproducible). With the camera, motor controller and microcontroller mapped to their devices in a compose file, the backend is built and started with a single command, `podman-compose up -d --build`.

#include "figures/nodes.typ"

=== Previous Work and Learnings <sec:real-prior>

// TODO: expand into prose. Ideas:
- @cyberrunner: what it demonstrated, and which parts of its hardware and node architecture are reused here (camera, state estimation, environment and algorithm, actuation).
- Its `dreamer` node combines the environment and the learning algorithm, so the environment cannot be used with other algorithms or frameworks. Here, the backend is a dependency of the environment instead.
- Software rot as an obstacle to reproduction: a specific ROS 2 release, an end-of-life Python version, unpinned dependencies, no NumPy 2 support (TODO give a concrete example of each).
- Conflicts with the toolchain used here: current RLlib DreamerV3 requires NumPy 2, and the simulation builds on current Gymnasium and MuJoCo releases.
- Why the original was not patched (bridging Gym to Gymnasium with Shimmy, decoupling the algorithm from the node): comparable effort to a reimplementation, which additionally yields a smaller codebase that is fully understood and maintainable.
- Changes relative to the original: no Kalman filter, an added inertial sensor, timestamps on sensor messages, limits on the range of motor movement.
- Learnings about camera latency and its measurement (see data in the results chapter).
- Learnings about the earlier Unity and ML-Agents marble maze project @marble_maze and why it was not extended.

=== Computer Vision <sec:real-cv>

State estimation from camera images constitutes the bulk of the backend. The pipeline recovers the position of the ball in the coordinate frame of the board, and the pose of the board relative to the camera, using classical methods of @CV implemented with OpenCV #footnote[TODO cite OpenCV]. It depends on two artifacts that are produced once per setup of the rig: the intrinsic parameters and distortion coefficients of the fisheye camera, obtained by a calibration procedure, and the image positions of reference markers on the board, selected manually in a fixed order. At runtime, the pipeline undistorts each frame, relates the image to the plane of the board by means of the marker correspondences, and locates the ball by color thresholding within a small sub-patch of the frame. The resulting estimates are published with the timestamp of the frame they were computed from, and are combined with the inertial measurements of the board.

#figure(
  todo-fig[Pipeline from a raw camera frame to the ball position in board coordinates and the board pose, with the calibration artifacts shown as inputs.],
  caption: [Overview of the state estimation pipeline.],
) <fig:cv-pipeline>

// TODO: subsections or paragraphs
- Camera model and fisheye calibration (camera intrinsics).
- Marker selection (`markers.csv`); board pose via PnP and the homography to the board plane.
- Ball detection with `inRange` in a sub-patch; robustness to lighting and occlusion; behavior when the ball is lost.
- Latency of the pipeline and how it is measured.
- Use of the inertial measurements, and why no Kalman filter is used.

== MuJoCo Backend <sec:sim>

The MuJoCo backend is a representation of the labyrinth in the physics engine, without any learning task attached to it. Its product is a single MuJoCo XML model that describes the geometry, joints, actuators and sensors of the rig along with the parameters of its dynamics. The model has to replicate the dimensions, dynamics and timing of the real rig closely enough for a policy to transfer (@req:sim_fidelity), while friction coefficients, masses, motor speeds and latencies remain exposed as parameters, so that they can be varied for @gl:DR (@req:sim_configurability). These requirements are summarized in @tbl:req-sim.

#figure(
  caption: [Requirements for the simulation backend.],
)[
  #include "tables/requirements-simulation.typ"
] <tbl:req-sim>

=== Engine <sec:sim-engine>

A range of simulators targeting robotics and @gl:RL research is available. Isaac Lab is a highly configurable framework, but its scope and infrastructure exceed the requirements of a single tilting maze. Gazebo is closely coupled to @gl:ROS, which the CyberRunner project employs, but we preferred a more contemporary toolchain that is not dependent on that ecosystem. General-purpose game engines such as Godot and Unreal Engine have likewise been used for @gl:RL. Unity was initially considered on pragmatic grounds, since the existing @gl:RL project @marble_maze provides a working foundation.

We ultimately chose @gl:MuJoCo @mujoco for its computational performance, in particular its GPU-parallel implementation MuJoCo Warp #footnote[TODO cite MuJoCo Warp]. It is also well suited to articulated mechanisms with hinges and actuators, and it provides a dedicated system identification package that is used to model the actuator dynamics (@sec:sim-sysid). Its collision detection requires concave shapes such as the maze to be decomposed into convex sub-shapes (@sec:sim-cad).

=== Maze Geometry <sec:sim-cad>

While generating meshes directly is computationally faster and can accelerate procedural level generation, the present scope is restricted to a single maze level. The primary objectives are therefore dimensional accuracy and implementation simplicity. To achieve this, we eschewed direct mesh generation -- and the Unity-based @gl:SVG importer provided by @marble_maze -- in favor of a @gl:CAD\-based approach. We selected build123d @build123d, an open-source @gl:CAD modeling library, due to its Pythonic interface. This programmatic approach yields parameterized models, and establishes a foundation that can later be extended to randomized mazes and curriculum learning. The maze layout is taken from the CyberRunner project, stored as data, and converted to the coordinate conventions of the model. Because @gl:MuJoCo requires convex shapes for collision meshes, the exported geometry is decomposed automatically using @gl:CoACD @coacd.

#figure(
  todo-fig[Side-by-side view of the maze @gl:CAD model and the resulting MuJoCo scene.],
  caption: [Maze geometry in CAD and in the MuJoCo scene.],
) <fig:maze-model>

=== MuJoCo Model <sec:sim-xml>

The exported meshes are assembled into the MuJoCo XML model, which is the core artifact of the backend. Besides the collision geometry of the maze and the ball, the model defines the hinges that tilt the board, the actuators that drive them, and the sensors whose outputs correspond to the quantities provided by the real backend. The physical parameters of the model are the subject of the following section.

=== System Identification <sec:sim-sysid>

Accurately replicating the dynamics of the system requires selecting a set of parameters such as friction coefficients and gear ratios. We use a gray-box system identification method, in which we explicitly measure certain values such as body weights and dimensions, and approximate the remaining parameters using regression methods (@fig:sysid).

// Preliminary; split as follows once final.
- Measured directly: masses of the ball and the board, dimensions of the board and the maze (TODO confirm which of these are taken from CAD and which are measured).
- Identified by regression: joint friction and damping, actuator gain and gear ratio, motor speed limit, contact parameters between ball and board, and actuation and sensing latency #footnote[TODO replace this list with the final set of attributes that need tuning, and state for each whether it is measured or identified.].

#figure(caption: [Black-box residual optimization])[
  #include "figures/sysid.typ"
] <fig:sysid>

The identification procedure uses the system identification package of MuJoCo. The real backend drives the actuators with prescribed excitation signals and records the resulting sensor measurements together with the commands, using the dedicated clients mentioned in @sec:real-arch. The same command sequence is then replayed in the simulation. The residual, which is the difference between the measured and the simulated sensor trajectories, is minimized with respect to the free parameters by nonlinear least squares, within bounds that keep the parameters physically plausible. Parameters that were measured directly are held fixed. The optimized values are written back into the MuJoCo XML model. // TODO confirm optimizer, bounds, and whether uncertainty estimates of the parameters are used.

== Environments <sec:task>

An environment defines what a learning algorithm observes, which actions it can take, which rewards it receives, and when an episode terminates. The definition of these quantities has to be identical in the real and the simulated domain for the outcomes of the two to be comparable (@req:run_comparability). It is derived from what is possible on the physical rig, since only quantities that can be sensed and actuated there can be part of it. The simulated environment is then built to match this definition, not the other way round.

#figure(
  todo-fig[A single task definition (observation, action, reward, termination) at the center, implemented by the real environment on top of the real backend and by the mjlab environment on top of the MuJoCo backend, with the real domain marked as the source of the constraints.],
  caption: [A common task definition implemented in both domains.],
) <fig:task-alignment>

=== Real Environment <sec:task-real>

The real environment is a Gymnasium environment that wraps the real backend. It subscribes to the state estimates published by the backend, assembles them into observations, translates actions into motor commands, and computes rewards and terminations from the estimated state. // TODO: this component may be replaced by an environment based on MuJoCo Playground; revise once decided.

=== mjlab Environment <sec:task-sim>

The simulated environment is an mjlab task #footnote[TODO cite mjlab] built on the MuJoCo backend. It declares observations, actions, rewards, and terminations through mjlab's manager-based API, and in addition defines the metrics by which policies are evaluated (@req:run_eval). Per-episode randomization of the physical parameters of the model for @gl:DR is declared in the same way (@req:run_parameterize). mjlab simulates large numbers of instances of the environment in parallel on a GPU, using MuJoCo Warp as the physics engine; this is handled by the framework and is not part of the environment definition. The simulated environment is accordingly not a Gymnasium environment, which sets it apart from the real environment even though both implement the same task definition.

== Runtimes <sec:runtime>

A runtime trains policies in an environment. We build on existing frameworks for this and develop only what they do not provide. The requirements for training and evaluation are given in @tbl:req-run.

#figure(
  caption: [Requirements for training and evaluation.],
)[
  #include "tables/requirements-pipeline.typ"
] <tbl:req-run>

=== Real Runtime <sec:runtime-real>

Training on hardware differs from training in simulation in that the environment cannot be stepped faster than real time, cannot be reset instantaneously, and cannot be copied. The real runtime therefore wraps the real environment with the means to train in these conditions. It builds on RLlib #footnote[TODO cite RLlib] for the learning algorithms, and logs to Weights & Biases #footnote[TODO cite Weights & Biases]. It is used to train and fine-tune policies on the rig (@req:run_baselines), and to import and export them (@req:run_checkpoint). // TODO: may be succeeded by mjlab or MuJoCo Playground; revise once decided.

// TODO: elaborate. Ideas:
- Control loop with a fixed step duration, whose clock rate is set by the runtime.
- Batched policy updates, so that learning does not interrupt the control loop.
- Export and import of policy modules between the two domains, and between runtimes.
- Support for multiple algorithms (PPO, DreamerV3), with identical observation and action spaces.
- Metrics logger that aggregates episode statistics for Weights & Biases (@req:run_data).

=== mjlab Runtime <sec:runtime-sim>

The mjlab runtime is provided by the framework. Training is started through the entry points of mjlab, with the RL algorithms supplied by rsl-rl #footnote[TODO cite rsl-rl], and metrics are logged to Weights & Biases.
