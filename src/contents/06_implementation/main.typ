= Implementation

== System Context

The @S2R pipeline is constructed by leveraging existing open-source software rather than developing its components from scratch. The CyberRunner project provides the image processing and motor actuation logic required for the real-world backend, while the Marble-Maze project supplies a fully featured Unity simulation that replicates the same physical environment. Ray RLlib serves as the framework for orchestrating the reinforcement learning components, offering reference implementations of @DreamerV3 and @PPO. To interface the simulation with the learning framework, Unity’s ML-Agents toolkit is employed; it manages the communication of observations between Python and Unity, advances the simulation at each step, and provides additional utilities such as domain randomization. Finally, Weights & Biases (WandB) is used to aggregate and log the metrics reported by Ray, thereby facilitating the monitoring and analysis of training progress.

#figure(caption: [Discrepancies between the existing simulation and real backend])[
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
  )
]
