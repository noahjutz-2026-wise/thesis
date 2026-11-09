#import "/src/common/util.typ": ref_requirement

= System Design

== Goals and Requirements <sec:requirements>

The hypothesis formulated in the problem statement can only be tested if the physical system and its simulation are comparable with respect to their dynamics and learning algorithm. The requirements in @tbl:requirements are derived from this condition and are grouped by the system to which they apply. Those concerning timing, state estimation and the parameters of the simulation determine the validity of the experimental results and are justified in more detail below the table.

#figure(
  caption: [Requirements for the real system, the simulation and both backends.],
)[
  #table(
    columns: 3,
    align: (center + horizon, start + horizon, start + horizon),
    stroke: (x, y) => if y == 0 {
      (bottom: 1pt)
    } else {
      (bottom: 0.3pt + luma(200))
    },
    table.header[*ID*][*Requirement*][*Rationale*],

    table.cell(colspan: 3, fill: luma(240))[*Simulation backend*],
    [#ref_requirement("req:sim_fidelity")],
    [Replicate dimensions, dynamics, timing],
    [Transferability],
    [#ref_requirement("req:sim_configurability")],
    [Parameter configurability],
    [@gl:DR],
    table.cell(colspan: 3, fill: luma(240))[*Real backend*],
    [#ref_requirement("req:real_determinism")],
    [Minimize stochasticity],
    [Faster learning],
    [#ref_requirement("req:real_safety")],
    [Safety (don't self-destruct)],
    [Unattended operation],
    [#ref_requirement("req:real_speed")],
    [Sufficient Frequency],
    [],
    [#ref_requirement("req:real_human")],
    [Humanoid actuation and sensing],
    [Comparability to human performance],
    table.cell(colspan: 3, fill: luma(240))[*Experiment pipeline*],
    [#ref_requirement("req:run_baselines")],
    [Train simulated and real baselines],
    [],
    [#ref_requirement("req:run_eval")],
    [Evaluation],
    [],
    [#ref_requirement("req:run_checkpoint")],
    [Save and transfer models],
    [@gl:S2R],
    [#ref_requirement("req:run_comparability")],
    [Stable conditions (algo+spaces)],
    [Comparable outcomes],
    [#ref_requirement("req:run_parameterize")],
    [Parameterization],
    [@gl:DR],
    [#ref_requirement("req:run_data")],
    [Collect data],
    [Answer RQ],
  )
] <tbl:requirements>

The simulation backend serves as the source domain and must therefore be a faithful enough replica of the physical labyrinth for a policy to transfer. It has to reproduce the geometry of the rig, the actuator and board dynamics, and the timing of sensing and actuation (@req:sim_fidelity), since a mismatch in any of these widens the reality gap. At the same time, these properties must not be hard-coded. Friction coefficients, masses, motor speeds, and latencies must be exposed as parameters (@req:sim_configurability), so that they can be sampled per episode and used for @gl:DR.

The real backend is the target domain and the source of the baseline, which places different demands on it. To make learning on the physical system as fast and stable as possible, sources of stochasticity that the agent cannot influence, such as jitter in the control loop, should be minimized (@req:real_determinism). Since the rig is failure-prone and subject to wear, it must protect itself from damaging commands, for example by limiting motor speeds and ranges of motion, so that training can run unattended (@req:real_safety). The control loop must also run at a sufficient frequency (@req:real_speed), comparable to the roughly 55 Hz of the baseline we compare against. Finally, the way the system is actuated and sensed should resemble that of a human player (@req:real_human), so that the achieved performance can be meaningfully compared to human performance.

The experiment pipeline ties both backends together and must answer the research question. It must be able to train baselines in simulation and in reality (@req:run_baselines) and to evaluate any policy with the metrics defined in the methodology (@req:run_eval). Because @gl:S2R relies on moving a model from one environment to another, models have to be saved and restored across backends (@req:run_checkpoint). For the outcomes of different experiments to be comparable, everything except the factor under study, in particular the algorithm and the observation and action spaces, has to remain fixed (@req:run_comparability). Each experiment is configured through a set of parameters, including those used for @gl:DR (@req:run_parameterize). Finally, data must be collected at every stage of a run (@req:run_data), as it is the basis for the analysis in the results chapter.

== Architectural Overview

// fig:components design decision justification by requirements

To achieve high fidelity simulation (@req:sim_fidelity), we need to do system identification. First, we need to take care of dimensions, which we achieve by #[@gl:CAD]-modeling a replica. Further, we need to take care of timing, which we achieve my manually measuring camera latency (the camera is the only sensor). Next, we need to take care of physical parameters, i.e. creating a simplified model of the actuator dynamics, which we do by treating it as a black box and regressing a model.

Necessitated by the requirement for stable conditions (@req:run_comparability) (such as algorithm implementation, spaces) across experiments, we create a standardized gymnasium interface for both backends.


// one hierarchy deeper in design decisions: opencv



An overview of components and their relationships is shown in fig:components.

(TODO fig:components)

== Simulation Backend

// - overview
//   - Mesh: build123d + CoACD
//   - Engine: MuJoCo
//     - Unity was evaluated
//   - Rendering: None
//   - Dynamics: sysid
//   - Parameterization: ?
//   - interface: gymnasium

=== Modeling

// CAD
While generating meshes directly is computationally faster and can accelerate procedural level generation, the present scope is restricted to a single maze level. Therefore, our primary objectives are high-fidelity dimensional accuracy and implementation simplicity. To achieve this, we eschewed direct mesh generation -- and the insufficiently configurable @gl:SVG importer provided by @marble_maze -- in favor of a #[@gl:CAD]-based approach. We selected build123d @build123d, an open-source @gl:CAD modeling library, due to its Pythonic interface. This programmatic approach facilitates rapid design drafting and the creation of parameterized models, establishing a robust foundation that can be extended in the future to support randomized mazes and curriculum learning. Furthermore, because @gl:MuJoCo requires convex shapes for collision meshes, we integrated @gl:CoACD @coacd to automatically decompose the generated geometry.

// Sensors, actuators


// System Identification
Accurately replicating the dynamics of the system requires selecting a set of parameters such as friction coefficients and gear ratios. We use a gray-box system identification method, in which we explicitly measure certain values such as body weights and dimensions, and approximate the remaining parameters using regression methods.

#figure(caption: [Black-Box residual optimization])[
  #include "figures/sysid.typ"
]

=== Simulating

A simulated environment consists of two core components: a simulation engine that approximates the physical interactions of the system, and a renderer that produces visual observations. The choice of engine involves a trade-off between physical fidelity and computational performance, and the ability to run many instances in parallel is an additional consideration. The engine must also support domain randomization through parameterized physics. The renderer, in turn, must reproduce the specifications of the real camera, including its intrinsic parameters and field of view, and must provide realistic lighting and materials that can themselves be randomized.

A range of simulators targeting robotics and @gl:RL research is available, and each makes different trade-offs. Isaac Lab is a highly configurable framework, but its scope and infrastructure exceed the requirements of a single tilting maze. Gazebo is closely coupled to @gl:ROS, which the CyberRunner project employs, but we preferred a more contemporary toolchain that is not dependent on that ecosystem. General-purpose game engines such as Godot and Unreal Engine have likewise been used for @gl:RL. Unity was initially considered on pragmatic grounds, since the existing @gl:RL project @marble_maze provides a working foundation. However, we ultimately chose @gl:MuJoCo @mujoco over Unity. Although MuJoCo's built-in renderer is not designed for high visual fidelity and its collision detection requires concave mazes to be decomposed into convex sub-shapes, it is highly suited to articulated mechanisms with hinges and actuators, and it provides a dedicated sysid package necessary for accurately modeling actuator dynamics.

== Real Backend

// We orient our work upon @cyberrunner @cyberrunner2 for establishing a control loop that senses and actuates the labyrinth during training and evaluation. In order to address hurdles including software rot #footnote[For example, old dependencies whose versions were not pinned make reproducing difficult], compatibility with new tools and libraries #footnote[For example, NumPy version 2 is unsupported.], and to include new requirements including consistent timing (@req:real_determinism) and operational safety (@req:real_safety), we found the path of least resistance was a reimplementation of the @cyberrunner codebase, while reusing its hardware and architecture. @cyberrunner[Sec 2]

The real backend provides the interface through which a learning algorithm senses and actuates the physical labyrinth during training and evaluation. It consists of a small set of asynchronous nodes for image acquisition, state estimation, inertial measurement, and actuation, which exchange messages with one another. A Gymnasium environment on top of these nodes exposes the hardware under the same interface as the simulation, so that policies can be trained and evaluated against either without modification. The environment is deliberately separated from both the hardware backend and the learning algorithm: the algorithm depends only on the Gymnasium interface, and the hardware nodes know nothing of the algorithm (@fig:nodes.reimpl). The labyrinth game is thereby available to researchers as a standardized Gymnasium environment, in simulation and on hardware, independent of the learning algorithm used. The remainder of this section describes the design of these components and how they address the requirements @req:real_determinism, @req:real_safety, @req:real_speed and @req:real_human in @sec:requirements.

The backend is a reimplementation of the control loop established in @cyberrunner @cyberrunner2, from which we take the hardware setup and the node architecture. In that design, a camera node, a computer vision node (`state_estimation`), a Gymnasium environment node (`dreamer`), and an actuation node (`dynamixel`) run as asynchronous processes and communicate via messages. These fundamental nodes of the @CR project are illustrated in @fig:nodes.cr. The `dreamer` node contains both the Gymnasium environment and the learning algorithm. The environment is thereby tightly coupled to a single algorithm, which makes it difficult to reuse with others.

We deviate from the original in the following respects. First, the vision pipeline omits the Kalman filter in favor of a simpler implementation. Second, we add a node that provides inertial measurements. Third, the original `dreamer` node combined the learning algorithm with the Gymnasium environment, whereas we keep the environment, the hardware backend, and the algorithm separate. Fourth, the actuation node runs a loop at a fixed frequency to obtain consistent timing. Fifth, the range of motor movement is limited, as unrestricted motion risks damaging the rig (@req:real_safety).

Most of these changes could have been applied to the original codebase. A fixed-frequency loop and an additional sensor node are compatible with its architecture, and we did not find the original to be unusable. We nevertheless chose to reimplement it, because its software environment conflicts with the libraries that our work depends on. The original is tightly coupled to a specific version of ROS 2 and targets an older Python version, which is end-of-life and no longer supported by several libraries we use. Its dependencies are not pinned, which makes the environment difficult to reproduce #footnote[For example, TODO]. Furthermore, we use the current RLlib implementation of DreamerV3, which requires NumPy 2, whereas the original codebase does not support it #footnote[TODO confirm]. Since the original `dreamer` node combined algorithm and environment, upgrading the algorithm independently was not possible without restructuring the node. Finally, our simulation builds off the MuJoCo environment of current Gymnasium releases. Supporting the same Gymnasium version in the real environment keeps both interfaces identical, which is relevant for sim-to-real transfer.

We considered patching the original codebase, for example by bridging from Gym to Gymnasium with Shimmy and decoupling the algorithm from the node. We judged the effort to be comparable to a reimplementation, which in addition yields a smaller codebase that we fully understand and can maintain.

#include "figures/nodes.typ"

// - overview
//   - messaging: ZMQ over IPC
//   - actuation: dynamixel-sdk + python
//   - sensing:
//     - Vision: OpenCV + Fisheye + PnP
//     - IMU
//   - control loop: linux os timer fd
//     - local inference and batch updates
//   - interface: gymnasium


== Experiment Pipeline

- overview
  - Algorithm: RLLib PPO / DreamerV3
  - Environment: sim: gymnasium, real: external inference server
  - logging: W&B
