= Results

== System Identification

#figure(caption: [Histogram of observed camera latencies (n samples over a period of m seconds).])[
  #include "figures/cam_latency.typ"
]

== Simulation Training

In an attempt to increase training performance of a simulation-trained policy, various changes to the observation space and reward shape of the task were made. Each change is applied in isolation to a baseline simulation environment. We trained each experiment for 500,000 steps with 5 different seeds. The results, which can be seen in @fig:sim_optim_methods, indicate no major benefits for any configuration. It is possible that the training iterations were insufficient to detect a sufficient change, or that there was another factor inhibiting learning.

#figure(caption: [Violin Plot of max return distribution for different experiments])[
  #include "figures/sim_optim_methods.typ"
] <fig:sim_optim_methods>

#figure(caption: [Training performance metrics for different @gl:DR conditions])[
  #include "figures/returns.typ"
]

== @S2R:long

#figure[
  #include "figures/s2r.typ"
]
