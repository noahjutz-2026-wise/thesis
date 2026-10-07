= Introduction

== Motivation

@DRL:both has proven to be applicable in various robotics tasks, including complex non-linear applications, and remains a promising field of study for all matter of control tasks. The trial-and-error learning method allows for developing novel solutions to problems without explicit direction given by the researcher due to its reward-based exploratory approach. By utilizing Deep @NN:pl for encoding behavior and world models, large continuous state spaces (e.g. camera images) and action spaces (e.g. motor target velocity) become tractable.

Training real-world systems entails new challenges that are subject to current research. Parallelizing learning requires purchasing the physical systems required for agents and environments, which is often prohibitively expensive. Manual supervision of failure-prone setups, maintenance of assemblies subject to constant wear and storage contribute to the costs of conducting research on real-world physical systems. The physical constraints of the real-world environment that agents act in impose a lower bound on the required wall-clock time for collecting a unit of experience. For example, resetting an environment might require waiting for the motors in a system to revert to their original position. Finally, equipment that is being used for training cannot be otherwise utilized in the mean time, increasing downtime. In summary, collecting experience in real-world experiments can become prohibitively expensive.

To address this issue, a multitude of solutions have been proposed, which can be categorized into those that aim to improve sample efficiency, and those that aim to lower the cost of generating samples. As for the former, developments to improve general-purpose learning algorithms -- such as learned world models and latent states @dreamerv3 -- are ongoing. The same can be said for application-specific efforts such as reward shaping, data augmenting and selective sampling @cyberrunner2. In this thesis, we want to focus on the latter case. By generating trajectories for training a model in simulation and transferring said model to the real world, we hope to reduce the amount of required training steps on the physical system. This strategy, known as @S2R, has seen a stark increase in research activity recently.

While @S2R offers a promising path toward lowering the cost of @RL research on control tasks, it introduces its own challenges. Replicating a system in simulation with high-fidelity dynamics requires not only a thorough understanding of the underlying physics but also careful modeling of sensor and actuator latencies. Furthermore, designers of simulated environments must navigate a set of interlocking trade-offs: simulation fidelity versus compute cost, the number of fine-tuning steps versus policy robustness, and the degree of domain randomization.

A central activity in @RL research is the design of benchmark environments, in order to evaluate algorithms and methods. Of particular interest in the field of @S2R are tasks that present a considerable discrepancy in the performance of a model in simulation and in the real world; this is known as a @RG. Studying control tasks which exhibit this difficulty helps us to figure out why some methods work well under ideal conditions, but fail to transfer to the real world. One such task is the BRIO Labyrinth Game: despite being conceptually simple and inexpensive to replicate, it exhibits continuous, nonlinear, and only partially observable dynamics, which is why @metzenBRIOLabyrinthGameA2009[a:] proposed it as a testbed for reinforcement learning @metzenBRIOLabyrinthGameA2009.

By adapting state-of-the-art @S2R methods in this environment, we can quantify and compare their efficacy, as well as identify the most prevalent challenges. Our main contributions are:

- *An evaluation of @S2R methods on the BRIO Labyrinth.* Building on existing hardware @cyberrunner @cyberrunner2 and simulation @marble_maze components, we transfer policies trained in simulation to the physical system and quantify both the reduction in environment steps required on the physical system and the residual reality gap. We additionally compare model-based and model-free algorithms for fine-tuning on the physical system.

- *Simulation fidelity extensions.* We extend the existing simulation of the labyrinth with configurable physical and timing parameters, such as actuator and sensor latencies, increasing its suitability as a source environment for @S2R.

- *A reproducible experiment pipeline.* We provide a clean, modular pipeline for training, transfer, and evaluation built on Ray RLlib @rllib, enabling the results of this thesis to be reproduced and the setup to serve as a foundation for future experiments on this task.

== Problem formulation

// Throughout this work, we are going to restrict our attention to a particular commercialy available marble maze game known as the BRIO Labyrinth. The goal is to navigate a marble through a labyrinth on a perforated surface. Players use two rotating knobs, which together control the rotation of the surface around two perpendicular axes. The resulting composed surface rotation determines the direction that ball gravitates toward.

We hypothesize that the accuracy of a model trained in a medium fidelity simulation remains within 15% of its fully real-world counterpart when deployed in the real world, while requiring 80% less real-world samples in fine-tuning. This is assuming that the @RG can be minimized

Since @cyberrunner2 achieved a 72% success rate by training only in the real world, we aim for at least 61.2%.

== Related work

To our knowledge, @waldemarkUsingReinforcementLearning1995 is the earliest published attempt to solve the labyrinth game with @RL. The author simulates the task using a frictionless physical model with rolling inertia and observes a marked performance degradation upon transfer to the real world, citing timing and noise as the dominant causes. The first works to employ dedicated simulation software, which additionally accounts for friction, are @abdenebaouiDiplomThesisImplementationEvaluation2007 and @abdenebaouiConnectionistArchitectureLearning2007. There, the maze is manually subdivided into a set of smaller subproblems, which are solved in a discrete action space.

The labyrinth game was first proposed as a benchmark environment by @metzenBRIOLabyrinthGameA2009, with an emphasis on the engineering aspects of automating the control task. The same environment later served as a testbed for @bergattQuantificationMinimizationSimulationRealityGap2009, in which a metric for quantifying the @RG is introduced. A similar, though not identical, physical setup is presented in @ofjallCombiningVisionMachine2016, which covers the entire pipeline from physical setup and control loop to visual object detection and learning. The authors were able to solve the maze by explicitly providing the algorithm with a model of the physical behavior of the maze.

A breakthrough was achieved by @cyberrunner, who applied a sample-efficient @RL algorithm to the labyrinth and surpassed the human record for the fastest play-time, without requiring simulated samples. In @cyberrunner2, they revised their approach through data augmentation and selective sampling, reducing the required training time from four hours to one and a half.

See @table:publications-brio for a systematic comparison of publications that use the labyrinth game or a similar environment.

#figure(caption: [Classification of publications tackling the labyrinth game])[
  #table(
    columns: 5,
    table.header([Reference], [Real platform], [Simulator], [Algorithm], [@S2R]),
    [@waldemarkUsingReinforcementLearning1995], [simplified BRIO], [Custom], [SRV-Net (RL)], [Direct policy transfer],

    [@abdenebaouiDiplomThesisImplementationEvaluation2007 @abdenebaouiConnectionistArchitectureLearning2007],
    [BRIO],
    [ODE],
    [QCON],
    [],

    [@metzenBRIOLabyrinthGameA2009], [BRIO], [ODE], [SARSA($lambda$) + CMAC], [✗],

    [@bergattQuantificationMinimizationSimulationRealityGap2009], [BRIO], [ODE], [Evolution], [],

    [@ofjallCombiningVisionMachine2016], [BRIO], [No], [LWPR], [#sym.crossmark],
    [@jhaLearningTasksComplex], [CME], [Custom], [MF + MB RL], [✗],
    [@baarSimtoRealTransferLearning2019], [CME], [Custom], [RL], [DR],
    [@otaDataEfficientLearningComplex2021], [CME], [Physics+GP], [NMPC], [Sys-ID, GP Res.],
    [@cyberrunner], [BRIO], [—], [DreamerV3], [✗],
    [@cyberrunner2], [BRIO], [—], [DreamerV3 + PER], [✗],
  )
] <table:publications-brio>
