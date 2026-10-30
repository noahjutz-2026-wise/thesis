#import "/src/common/util.typ": ref_requirement

= System Design

== Goals and Requirements <sec:requirements>

The hypothesis formulated in the problem statement can only be tested if the physical system and its simulation are comparable with respect to their dynamics and learning algorithm. The requirements in @tab:requirements are derived from this condition and are grouped by the system to which they apply. Those concerning timing, state estimation and the parameters of the simulation determine the validity of the experimental results and are justified in more detail below the table.

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
    [@DR],
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
    [@S2R],
    [#ref_requirement("req:run_comparability")],
    [Stable conditions (algo+spaces)],
    [Comparable outcomes],
    [#ref_requirement("req:run_parameterize")],
    [Parameterization],
    [@DR],
    [#ref_requirement("req:run_data")],
    [Collect data],
    [Answer RQ],
  )
] <tab:requirements>

The simulation backend serves as the source domain and must therefore be a faithful enough replica of the physical labyrinth for a policy to transfer. It has to reproduce the geometry of the rig, the actuator and board dynamics, and the timing of sensing and actuation (@req:sim_fidelity), since a mismatch in any of these widens the reality gap. At the same time, these properties must not be hard-coded. Friction coefficients, masses, motor speeds, and latencies must be exposed as parameters (@req:sim_configurability), so that they can be sampled per episode and used for @DR.

The real backend is the target domain and the source of the baseline, which places different demands on it. To make learning on the physical system as fast and stable as possible, sources of stochasticity that the agent cannot influence, such as jitter in the control loop, should be minimized (@req:real_determinism). Since the rig is failure-prone and subject to wear, it must protect itself from damaging commands, for example by limiting motor speeds and ranges of motion, so that training can run unattended (@req:real_safety). The control loop must also run at a sufficient frequency (@req:real_speed), comparable to the roughly 55 Hz of the baseline we compare against. Finally, the way the system is actuated and sensed should resemble that of a human player (@req:real_human), so that the achieved performance can be meaningfully compared to human performance.

The experiment pipeline ties both backends together and must answer the research question. It must be able to train baselines in simulation and in reality (@req:run_baselines) and to evaluate any policy with the metrics defined in the methodology (@req:run_eval). Because @S2R relies on moving a model from one environment to another, models have to be saved and restored across backends (@req:run_checkpoint). For the outcomes of different experiments to be comparable, everything except the factor under study, in particular the algorithm and the observation and action spaces, has to remain fixed (@req:run_comparability). Each experiment is configured through a set of parameters, including those used for @DR (@req:run_parameterize). Finally, data must be collected at every stage of a run (@req:run_data), as it is the basis for the analysis in the results chapter.

== Architectural Overview

// fig:components design decision justification by requirements

To achieve high fidelity simulation (@req:sim_fidelity), we need to do system identification. First, we need to take care of dimensions, which we achieve by #[@CAD]-modeling a replica. Further, we need to take care of timing, which we achieve my manually measuring camera latency (the camera is the only sensor). Next, we need to take care of physical parameters, i.e. creating a simplified model of the actuator dynamics, which we do by treating it as a black box and regressing a model.

Necessitated by the requirement for stable conditions (@req:run_comparability) (such as algorithm implementation, spaces) across experiments, we create a standardized gymnasium interface for both backends.


// one hierarchy deeper in design decisions: opencv



An overview of components and their relationships is shown in fig:components.

(TODO fig:components)

== Real Backend

- overview
  - messaging: ZMQ over IPC
  - actuation: dynamixel-sdk + python
  - sensing:
    - Vision: OpenCV + Fisheye + PnP
    - IMU
  - control loop: linux os timer fd
    - local inference and batch updates
  - interface: gymnasium

== Simulation Backend

- overview
  - Mesh: build123d + CoACD
  - Engine: MuJoCo
    - Unity was evaluated
  - Rendering: None
  - Dynamics: sysid
  - Parameterization: ?
  - interface: gymnasium

== Experiment Pipeline

- overview
  - Algorithm: RLLib PPO / DreamerV3
  - Environment: sim: gymnasium, real: external inference server
  - logging: W&B
