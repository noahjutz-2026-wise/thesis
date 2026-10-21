= Implementation

== System Context

The @S2R pipeline is assembled primarily from existing open-source software rather than from newly developed components. On the @RL side, the pipeline requires an implementation of a policy-training algorithm, a mechanism for logging metrics throughout experiments, as well as managing datasets, trained models and checkpoints. The environment side comprises two interchangeable backends: a simulation that reproduces the labyrinth game, and a physical system together with the control software that actuates it. Both backends are abstracted behind a common, standardized interface, which allows the @RL component to request samples and drive the agent without regard to whether it is interacting with the simulated or the physical environment. Finally, an orchestration layer sits above these components to run experiments under varying parameter configurations and to compare their outcomes systematically.

The choice of algorithm implementation warrants careful consideration, as seemingly minor implementation details can lead to substantial differences in performance @shengyi2022the37implementation. Stable-Baselines3 @stable_baselines3 offers well-established reference implementations that emphasize simplicity. Implementations of the same algorithm also differ in practical respects, such as their support for parallelization and their compatibility with the surrounding simulation stack. For instance, RSL-RL and skrl are frequently used together with widely adopted simulation frameworks, and ML-Agents @mlagents ships with its own implementation of @PPO. We ultimately adopted the @PPO and @DreamerV3 implementations provided by RLlib @rllib, owing to its tight integration with the Ray ecosystem. This integration additionally simplifies model checkpointing and transfer, and it provides callbacks for logging metrics during training.

Keeping track of experiments, their configurations, outcomes, and artifacts can be facilitated with tooling. It is important to warrant reproducability by noting down not only the used configuration and seed for a run, but also referencing the exact code revision that was used. Metrics that result from training should be collected without interfering (e.g. by blocking). Large files including trained models and raw image observations need to be kept track of en masse. Tools such as HuggingFace datasets, ML-flow and Data Version Control provide part of the solution. We landed on @WandB despite its centralized architecture due to its simplicity and ability to satisfy all requirements.

A simulated environment consists of two core components: a simulation engine that approximates the physical interactions of the system, and a renderer that produces visual observations. The choice of engine involves a trade-off between physical fidelity and computational performance, and the ability to run many instances in parallel is an additional consideration. The engine must also support domain randomization through parameterized physics. The renderer, in turn, must reproduce the specifications of the real camera, including its intrinsic parameters and field of view, and must provide realistic lighting and materials that can themselves be randomized.

A range of simulators targeting robotics and @RL research is available, and each makes different trade-offs. MuJoCo is well suited to articulated mechanisms with hinges and actuators, but its collision detection operates on convex geometry, so a concave maze would have to be decomposed into convex sub-shapes. Its built-in renderer is also not designed for high visual fidelity, although MuJoCo can be integrated into Unity. Isaac Lab is a highly configurable framework, but its scope and infrastructure exceed the requirements of a single tilting maze. Gazebo is closely coupled to ROS, which the CyberRunner project employs, but we preferred a more contemporary toolchain that is not dependent on that ecosystem. General-purpose game engines such as Godot and Unreal Engine have likewise been used for @RL. Unity was selected on pragmatic grounds, since the existing @RL project @marble_maze provides a working foundation on which to build.

#figure(caption: [Discrepancies between the existing simulation and real backend])[
  #show table.cell.where(x: 0): rotate.with(90deg, reflow: true)
  #table(
    columns: 3,
    align: horizon,
    table.header([], table.vline(), [*CyberRunner*], [*Marble-Maze*]),
    table.hline(),
    [*Obs*],
    $
      mat(
        delim: "{",
        #[`image`:] & {0,...,255}^(64 times 64 times 1);
        #[`states`:] & vec(x_b, y_b, alpha, beta);
        #[`goal`:] & vec(x_(g,1), y_(g,1), ..., x_(g,5), y_(g,5));
        #[`progress`:] & l in RR;
      )
    $,
    $
      vec(
        x_b, y_b,
        alpha, beta,
        bold(upright(p))_(h,1),
        ...,
        bold(upright(p))_(h,5),
        bold(upright(v))^"nav"_x,
        0,
        bold(upright(v))^"nav"_z,
        l,
        d^"ray"_1,
        ...,
        d^"ray"_8
      )^10
    $,

    [*Act*],
    [$[-1, 1]^2$ (Target Speed)],
    [$[-1, 1]^2$ (Target rotation)],

    [*Rew*],
    $
      r_t & = Delta_l \
      r_T & = 0
    $,
    $
      r_t & = -0.005 + 0.5 Delta_l + bold(m)_"bonus" dot bb(1)_(m_t>m_(t-1)) \
      r_T & = cases(
              +5 & "if goal",
              -0.2 & "if hole",
              0 & "if stall",
              -0.005 & "if truncated"
            )
    $,
    [*Terminal State*],
    $
      n >= ? or \
      "goal" or \
      "hole"
    $,
    $
      n >= 50.000 or \
      t_"stall" >= ? or \
      "goal" or \
      "hole"
    $,
  )
]
