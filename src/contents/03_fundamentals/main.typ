= Theoretical Foundation

== @RL:long

Originating from dynamic programming @bellmanDynamicProgramming1957, @RL:both learns to solve _multi-stage processes_ via trial and error @bartosutton. It models interactions as @MDP:pl across discrete steps $t$: a _deterministic policy_ $pi(s)$ or _stochastic policy_ $pi(a|s)$ selects actions $a_t in cal(A)$ for a given _state_ $s_t in cal(S)$, generating an immediate _reward_ $r$ and next state according to the system's _dynamics_ $p(s', r | s, a)$ and _reward function_ $r(s, a, s')$. This interaction yields a _trajectory_ $S_0,A_0,R_1,S_1,A_1,R_2,...$ with the ultimate goal of finding an _optimal policy_ that maximizes the cumulative _return_ $G_t$.

// State value and action value methods


// A _policy_ governs these decisions. An _optimal policy_ maximizes some metric within the variables that define the physical system.


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
