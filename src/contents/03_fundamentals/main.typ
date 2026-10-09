= Theoretical Foundation

== @RL:long

Born out of the field of dynamic programming, @RL:both is a branch of study that is concerned with learning to solve problems through trial and error @bartosutton.

A problem definition for _multi-stage processes_ was formalized in @bellmanDynamicProgramming1957 as finding the optimal sequence of choices which influence the variables that define the state of a physical system over time. Optimality is defined here as maximizing or minimizing some metric derived from the system's state.

The fundamental model for a control loop in @RL are @MDP:pl: The interaction is structured as a series of discrete time steps $t$. The set of variables that describe the system at time $t$ are contained within the _state_ of the system $s_t in cal(S)$. There is a function which maps states to actions (in the deterministic case; $pi(s)$), or to action-probabilities (in the stochastic case; $pi(a|s)$).

A _deterministic policy_ $pi(s)$ chooses an action $a_t in cal(A)$ given the current state, whereas a _stochastic policy_ $pi(a|s)$ yields the probability of choosing an action $a_t$ in the current state $s_t$. A _reward function_ $r(s, a, s')$ provides us with an objective to optimize against: Given the current state $s$, the taken action $a$ and subsequent state $s'$, it determines a scalar immediate _reward_ $r$.

Putting this all together, a _trajectory_ $S_0,A_0,R_1,S_1,A_1,R_2,...$ consists of an environment state, which is manipulated in each step by an action chosen by a policy, resulting in a subsequent state and reward. How an action $a$ influences the state is stochastically determined by the _dynamics_ of the system $p(s', r | s, a)$. The reward function is derived from it.

The goal of sequential decision making is to maximize the cumulative reward obtained over time, or _return_ $G_t$. The problem lies in finding an _optimal policy_ that

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
