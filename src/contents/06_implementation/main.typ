= Implementation

== System Context

The @S2R pipeline is constructed by leveraging existing open-source software rather than developing its components from scratch. On the @RL side, we require an algorithm implementation for training a policy. In addition, we need a means to collect metrics during experiments, and the ability to export and import models. In terms of the backing environment, we need a simulation that replicates the labyrinth game. In addition, we need a physical system and code that actuates it. Lastly, we need to generalize both branches into a standardized interface so that the @RL side can request samples and drive the agent.

A simulated environment requires a simulation engine, which approximates physical interactions, and a renderer for visual observations. We choose the unity game engine


// while the Marble-Maze project supplies a fully featured Unity simulation that replicates the same physical environment. Ray RLlib serves as the framework for orchestrating the reinforcement learning components, offering reference implementations of @DreamerV3 and @PPO. To interface the simulation with the learning framework, Unity’s ML-Agents toolkit is employed; it manages the communication of observations between Python and Unity, advances the simulation at each step, and provides additional utilities such as domain randomization. Finally, Weights & Biases (WandB) is used to aggregate and log the metrics reported by Ray, thereby facilitating the monitoring and analysis of training progress.

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
