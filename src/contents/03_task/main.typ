= Task

The labyrinth game is an episodic, indefinite-horizon, partially observable, single-agent, stationary navigation task.


The reward function, observation space, action space, physical parameters, geometry, visual aspects, and dynamics shall be detailed here.

== Reward Function and Spaces

We reuse the reward function in @cyberrunner2. $N$ evenly spaced waypoints $upright(bold(w)) in RR^(2 times N)$ are laid out along the optimal path. At any given timestep $t$, the current progress $l$ is assigned to the index of the milestone, which is closest to the current ball position $bold(upright(b))_t in RR^2$ (@eq_waypoint).

$
  l_t = limits(arg min)_(i) norm(bold(upright(w))_i - bold(upright(b))_t)_2
$ <eq_waypoint>

The reward at $t$ is the difference between the progress at $t-1$ and $t$ (@eq_waypoint_diff).

$
  r(s) = Delta_l = l_t-l_(t-1)
$ <eq_waypoint_diff>

A defining feature in the @CR project is its ability to work with only a camera image and its derived features. Using markers on the rig and reference markers fixed in place, the plate pose and ball position are estimated. A 64 by 64 pixel greyscale subimage is attached to the observation. Finally, the next $N=5$ waypoints relative to the ball are provided.

As for the action space, a normalized continuous value in $[-1, 1]$ is passed for each of the two motors. By multiplying with a current value, we can tune the real-world motor speed this corresponds to.

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
      "hole" or \
      "cheated"
    $,
    $
      n >= 50.000 or \
      t_"stall" >= ? or \
      "goal" or \
      "hole"
    $,
  )
]
