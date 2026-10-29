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
    table.cell(colspan: 3, fill: luma(240))[*Experiment pipeline*],
    [#ref_requirement("req:run_comparability")],
    [Stable conditions (algo+spaces)],
    [Comparable outcomes],
    [#ref_requirement("req:run_parameterize")],
    [Parameterization],
    [@DR],
    [#ref_requirement("req:run_data")],
    [Collect data],
    [Answer RQ],
    [#ref_requirement("req:run_checkpoint")],
    [Save and transfer models],
    [],
  )
] <tab:requirements>

constraints:
- actuation same as human
- sensing only through camera

== Architectural Overview

// fig:components design decision justification by requirements

To achieve high fidelity simulation (@req:sim_fidelity), we need to do system identification. First, we need to take care of dimensions, which we achieve by #[@CAD]-modeling a replica. Further, we need to take care of timing, which we achieve my manually measuring camera latency (the camera is the only sensor). Next, we need to take care of physical parameters, i.e. creating a simplified model of the actuator dynamics, which we do by treating it as a black box and regressing a model.

Necessitated by the requirement for stable conditions (@req:run_comparability) (such as algorithm implementation, spaces) across experiments, we create a standardized gymnasium interface for both backends.


// one hierarchy deeper in design decisions: opencv



An overview of components and their relationships is shown in fig:components.

(TODO fig:components)
