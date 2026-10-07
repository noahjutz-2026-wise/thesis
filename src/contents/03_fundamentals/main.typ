= Theoretical Foundation

== @RL:long

@RL:both is a branch of study that is concerned with learning to solve arbitrary problems through trial and error. It is born out of the field of dynamic programming, which provides us with a formal definition of the problem we are trying to solve. Bellman TODO defines a _multi-stage decision process_ as a sequence of choices which influence the variables that define the state of a physical system over time. A _policy_ governs these decisions. An _optimal policy_ maximizes some metric within the variables that define the physical system.


Fundamentals
- @MDP:pl:short, Policy, Value Function, Exploration-Exploitation tradeoff @bartosutton
- Model-based, On-Policy
// - Monte Carlo, n-step TD (sarsa, Q-learning) @bartosutton
- Approximation function @bartosutton

Deep @RL
- @NN:pl?
- Batching?

@PPO
- @PPO @ppo @gae @suttonPolicyGradientMethods

Dreamer
- Dreamer, dyn-rec-pol loss, Imagination @dreamerv1 @dreamerv3

== Real-World System

- @cyberrunner @cyberrunner2 (@CR)

== Simulated System

- @mlagents (@MLAgents)

== @S2R:long

- @zhaoSimtoRealTransferDeep2020a (Survey)
- @salvatoCrossingRealityGap2021 (Survey)

== Delay-aware @RL

- @nathRevisitingStateAugmentation2021 (Formale Definition)
- @yuanAsynchronousReinforcementLearning2022 (engineering reference)
- @jiModelingDynamicsRandom2026 (bezug zu DreamerV3)

== Implementation

- #text(gray)[Ray]
- #text(gray)[RLLib]
- #text(gray)[PyTorch]
- #text(gray)[TorchRL]
