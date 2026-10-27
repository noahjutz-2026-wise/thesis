= Theoretical Foundation

== @RL:long

Originating from dynamic programming @bellmanDynamicProgramming1957, @RL:both is an optimization technique for learning how to make good sequences of decisions through trial and error @bartosutton. Two entities take part in this process. The _agent_ is the decision maker that is being trained. The _environment_ is everything outside the agent that it can influence through its decisions and observe the consequences of, for example a simulated game or a physical robot with its surroundings. The agent's behavior is determined by its _policy_ $pi$, which is a function that, given the current situation, decides what the agent does next. Training means improving this policy based on the outcomes the agent experiences while interacting with the environment, without being told in advance which decisions are correct.

This interaction is formalized as a @MDP, which proceeds in discrete _time steps_ $t = 0, 1, 2, ...$. In each step, the agent perceives the current _state_ $s$ of the environment, selects an _action_ $a$, and receives a numeric _reward_ $r$ that indicates how desirable the outcome was. The environment then transitions to a _subsequent state_ $s'$, and the cycle repeats. The following sections define these quantities in detail. The resulting sequence of alternating states, actions, and rewards is called a _trajectory_ and begins as shown in @eq_trajectory.

$
  S_0,A_0,R_1,S_1,A_1,R_2,S_2,A_2,R_3,...
$ <eq_trajectory>

The environment does not respond to the agent's actions deterministically: taking the same action in the same state may lead to different subsequent states and rewards. This stochastic behavior is captured by the _environment dynamics_, a probability distribution $p(s', r | s, a)$ over the _subsequent state_ $s'$ and the reward $r$ that follow from taking action $a$ in state $s$, as shown in @eq_dynamics.

$
  p(s', r | s, a) = Pr(S_t=s', R_t=r | S_(t-1)=s, A_(t-1)=a)
$ <eq_dynamics>

Together, the dynamics and the policy determine how likely a complete trajectory is. Since the agent chooses actions according to $pi(a|s)$ and the environment transitions according to the dynamics, the probability of a trajectory $tau$ under a policy $pi$ factorizes into the distribution $p(s_0)$ of the initial state times the probabilities of each action and transition along the way, as shown in @eq_trajectory_distribution.

$
  p(tau) = p(s_0) product_(t=0)^oo pi(a_t|s_t) p(s_(t+1), r_(t+1) | s_t, a_t)
$ <eq_trajectory_distribution>

Tasks differ in how a trajectory ends. _Episodic_ tasks group steps into _episodes_, each of which ends in a _terminal state_, for example when a goal is reached, a failure occurs, or a time limit expires. After that, the environment is reset and a new episode begins. This is in opposition to _continuing_ tasks, which have no terminal state and go on indefinitely, as is the case for a controller that regulates a process around the clock.

The variables that define the situation of the environment at any given time are encapsulated within a number of numeric values, collectively comprising the _state_. The _state space_ $cal(S)$ is the set of all possible states the environment could find itself in. It may be finite in the case of simple environments such as Minigrid [CITATION NEEDED], where the state describes positions on a grid, or infinite when a variable is continuous, as is the case in real-world systems where quantities such as positions and velocities can take any real value.

A state fulfills the _Markov property_ if it contains all information from the past that is relevant for future decision making. In other words, knowing the history of earlier states and actions does not help predict what happens next any better than the current state alone. The decision process is then called Markovian, which is what the term @MDP:long refers to. This requires that the agent can see every variable that is relevant for decision making, in which case the environment is _fully observable_. However, due to inaccuracies and delays in sensors, this is usually not the case in real-world systems. There, the agent does not receive the true state but only an _observation_, which may be noisy or lack some information. Such tasks belong to the class of @POMDP:pl, in which the agent has to make decisions based on incomplete information.

The decision a policy has to make lies in choosing an appropriate _action_ $a$ at every time step. The _action space_ $cal(A)$ is the set of all actions the agent can choose from, and $cal(A)(s)$ denotes the actions that are available in a particular state $s$. Like the state space, the action space can be discrete (e.g. choosing a direction on a grid) or continuous (e.g. a motor target velocity).

In order to optimize the actions we take, we have to quantify their efficacy somehow. The primary mechanism for this is the _reward_, which is a scalar value the environment emits after each step. Since the goal in @RL is to manipulate the environment in some desirable way, we design a _reward function_ $r(s, a, s')$ that maps a transition, i.e. taking action $a$ in state $s$ and ending up in state $s'$, to a reward that correlates with the desirability of this outcome. The agent always tries to maximize the reward, so good outcomes can be rewarded with a positive signal, and bad outcomes can be punished with a negative one.

The design of the reward function strongly influences how easily a policy can be trained. A reward function is _sparse_ when only few transitions lead to a significant positive or negative reward, for example when the agent is only rewarded upon reaching the goal. This makes it difficult for an agent to reliably tell which of its many preceding actions led to the reward. It is easier for a policy to converge if it is constantly fed rewards by a _dense_ reward function, which provides frequent feedback on progress. A good reward function bases its output on outcomes rather than methods, so that agents can develop potentially novel methods to solve a task optimally instead of being forced to imitate a prescribed one. Designing the reward function in this way is also called _reward shaping_.

It would be short-sighted to decide actions solely based on the immediate reward, since an action with a small immediate reward may enable large rewards later. That's why the goal in @RL is to maximize the _return_ $G_t$, defined explicitly as the discounted sum of future rewards in @eq_return_sum. For finite-horizon tasks with terminal step $T$, the sum truncates at $T$, whereas for continuing tasks, an infinite horizon is used.

$
  G_t = sum_(k=0)^oo gamma^k R_(t+k+1)
$ <eq_return_sum>

Here, $0<=gamma<=1$ is the _discount rate_, which weighs immediate rewards more than distant ones to account for uncertainty and ensure finite values in continuing tasks. The return can also be expressed recursively as shown in @eq_discounted_return.

$
  G_t = R_(t+1) + gamma G_(t+1)
$ <eq_discounted_return>

The overall objective of reinforcement learning is to find a policy $pi$ that maximizes the expected return over full trajectories, formalized by the performance objective $J(pi)$ in @eq_rl_objective.

$
  J(pi) = EE_(tau ~ pi) [G_0]
$ <eq_rl_objective>

To decide which action is best, a policy needs a way to judge how promising a state or an action is in terms of the return it can be expected to lead to. The _state value_ $V(s)$ is the expected return when starting in state $s$ and following the policy thereafter. Likewise, the _action value_ $Q(s, a)$ is the expected return when starting in state $s$, taking action $a$, and following the policy thereafter. Methods that learn such estimates and derive their behavior from them are called value-based. A policy is _greedy_ with respect to $Q$ if it always selects the action with the highest estimated action value, as shown in @eq_greedy. Doing the same based on $V(s)$ alone would require knowing which state each action leads to.

$
  pi(s) = arg max_a Q(s, a)
$ <eq_greedy>

As an example of how value estimates can be learned, consider tabular Monte Carlo control. _Tabular_ means that the state and action spaces are finite and small enough that one estimate can be stored for every state-action pair in a table. _Monte Carlo_ means that the estimates are computed from returns actually observed by sampling complete episodes, rather than from other estimates. _Control_ means that the goal is to find a good policy, as opposed to merely evaluating a given one. After each episode, the return $G_t$ that followed each visited state-action pair is used to nudge the corresponding table entry towards it, using the update rule in @eq_update_rule. Here, $alpha$ is the _learning rate_, which determines how much an estimate changes in a single update. If $alpha = 1/n$, where $n$ is the number of times the pair has been visited, the estimate is the _sample average_ of all returns observed for it.

$
  Q(s_t,a_t) <- Q(s_t, a_t) + alpha [G_t - Q(s_t, a_t)]
$ <eq_update_rule>

So far we have established how values can be estimated, but not how a policy can benefit from this calculation to improve over time. The process of making the estimates match the current policy is called _policy evaluation_, and the process of making the policy greedy with respect to the current estimates is called _policy improvement_. When iterating between collecting trajectories to update the estimates and acting on the updated estimates, this creates a moving target for both the policy and the estimator. As the estimate becomes more accurate, the policy becomes more informed in choosing actions, and as the policy changes its behavior accordingly, the estimate updates to reflect the new trajectories. This feedback loop is referred to as @GPI.

Up to this point we have treated policies as _deterministic_, meaning that they always choose the same action in a given state, and greedy. This is rarely the case during training. Always choosing the action currently believed to be best is called _exploitation_. It can be detrimental for learning, since alternative pathways that could yield higher rewards are never tried. Trying actions or states that are unfamiliar in order to gather new information is called _exploration_, and balancing the two is known as the exploration-exploitation tradeoff. That's why we generally view policies as _stochastic_ functions that yield the probability of selecting an action given a state, written $pi(a|s)$. For example, an _epsilon-greedy_ policy with a parameter $0<=epsilon<=1$ chooses the greedy action with a probability of $1-epsilon+epsilon/abs(cal(A)(s))$, and any other action with a probability of $epsilon/abs(cal(A)(s))$. In effect, it picks a uniformly random action with probability $epsilon$ and the greedy action otherwise. Besides randomizing actions, methods exist to facilitate exploration by additionally rewarding the agent for visiting unseen states.

The randomness of a policy, which is measured by its _entropy_, is highest when all actions are equally likely and zero when it is deterministic. While a high entropy can be beneficial for exploration during training, it may be preferable to always exploit once the policy has been deployed. To do this, the _behavior policy_ of an algorithm, which is the policy used to collect experience during training, should differ from its _target policy_, which is the policy that is being learned and evaluated. We call this type of learning _off-policy_, as opposed to _on-policy_ learning, where both are the same. For example, an epsilon-greedy behavior policy used during training can be swapped out for a greedy target policy during inference.

Finally, another aspect of @MDP:pl to be taken into account is the environment's dynamics introduced earlier: if they are known, they form a _model_ of the environment, since they allow predicting the consequences of actions. If the dynamics are known, the training algorithm is said to be _model-based_, because it can plan ahead using them. Otherwise, it is said to be _model-free_ and has to rely on experienced samples alone.

In summary, @RL is all about learning a policy that takes a state as input and provides actions as output, in order to maximize the expected return, which is the cumulative, possibly discounted, reward. An episode consists of a trajectory of alternating states, actions, and rewards, which begins as seen in @eq_trajectory. Important considerations aside from algorithm implementation details are observability, reward design, and the exploration-exploitation tradeoff.

== @DRL:long

In settings with continuous state and action spaces, tabular representations, which store one value estimate per state or state-action pair, are not applicable. Such a table cannot enumerate an infinite set of states, and it cannot generalize from visited to unvisited states. Algorithms therefore rely on function approximation, in which policies, value functions, or environment models are represented by parametrized functions. Neural networks are a particularly expressive class of such approximators, since they can represent mappings from states to actions as well as to value estimates. In supervised learning, labeled data are available: the network output is compared with the true label, a loss function quantifies the discrepancy, the gradient of this loss with respect to the network parameters is computed via backpropagation, and the parameters are updated using optimization methods such as stochastic gradient descent.

In @RL, no labeled data are available. The learning signal is the reward received through interaction with the environment, so training targets must be constructed from the agent’s own experience, for example from sampled returns or from estimates of future reward produced by the network itself. Consequently, the data distribution depends on the current behavior of the agent and changes as learning progresses, in contrast to the fixed dataset assumed in supervised learning.

Two function approximators are central to the algorithms considered in this thesis. The policy (or actor) maps a state to a probability distribution over actions. The value function (or critic) estimates the expected future return from a given state and thus evaluates how good the current situation is under the policy. Methods that learn both are called actor-critic methods: the critic’s estimate is used to judge whether an action performed better or worse than expected, and the actor is adjusted accordingly. This corresponds to @GPI, where the critic carries out policy evaluation and the actor carries out policy improvement via gradient updates instead of greedy maximization, which is impractical for continuous actions. Both @PPO @ppo and @DreamerV3 @dreamerv3 belong to this family and differ mainly in the data from which actor and critic are trained.

@PPO is a model-free actor-critic algorithm. It collects a batch of trajectories with the current policy in the environment and uses it to update the actor and critic networks. A central difficulty of policy-based methods is that an overly large update can degrade the policy and, because new data are collected with this policy, hinder recovery. @PPO addresses this by comparing the probability of an action under the updated policy to its probability under the policy that collected the data, and by clipping this ratio to a small interval around one. Updates that would move the policy too far from the data-collecting policy therefore receive no additional incentive. This promotes stable learning and allows multiple gradient updates on the same batch, which improves data usage compared to a single update per batch. For continuous actions, the actor outputs the parameters of a probability distribution over actions, from which actions are sampled during training.

@DreamerV3 is a model-based actor-critic algorithm. Instead of learning solely from real environment interaction, it learns a world model, a neural network that encodes observations into a compact latent state and predicts how this state evolves given the agent’s actions, along with the resulting rewards. To ensure the latent state retains task-relevant information, the world model is trained to reconstruct the observations. Actor and critic are then trained on trajectories imagined in this latent space, starting from states encountered in real experience. Because imagined trajectories can be generated at no cost to the real environment, DreamerV3 requires considerably fewer real interactions than model-free methods. The approach depends on the accuracy of the learned world model: errors in the model can mislead the actor and critic.

Despite these differences, @PPO and @DreamerV3 share a training structure in which data collection and parameter updates are decoupled. Instead of updating the networks on each transition as it arrives, both algorithms first gather experience and then perform multiple gradient updates on randomly drawn minibatches, which reduces the correlation between consecutive samples and allows the same data to be used repeatedly.

// Algorithms
// - Monte Carlo
// - N-Step TD
// - TD(Lambda)

== @S2R:long

@S2R refers to training a policy in a simulated environment, the source domain, and deploying it on the physical system, the target domain, where it is expected to solve the task. Because a simulator is only an approximation of the physical system, the two domains differ. The resulting discrepancy between simulated and real performance of a policy is called the @RG @salvatoCrossingRealityGap2021. Following @zhaoSimtoRealTransferDeep2020a, two sources can be distinguished. The first concerns the observations: images or sensor readings produced by the simulator differ from those of real sensors, so the policy receives inputs it has not seen during training. The second concerns the dynamics: the physical system responds differently to the same action than the simulator predicts, for example due to inaccurately modeled masses, friction, or actuators. A policy can fail in the target domain because of either source.

Among the most common techniques in @S2R are System Identification, @DR, Domain Adaptation and Imitation Learning @zhaoSimtoRealTransferDeep2020a.

_System Identification_ is the process of creating an idealized mathematical model for sensors and actuators that approximately replicates the behavior of the real system.

_#[@DR]_ can be applied to visuals and dynamics. Altering textures and lighting during training can robustify the policy agains these perturbations during inference. As it pertains to dynamics randomization, dimensions, masses and friction coefficients are examples for targets of randomization.


// == Delay-aware @RL
//
// - @nathRevisitingStateAugmentation2021 (Formale Definition)
// - @yuanAsynchronousReinforcementLearning2022 (engineering reference)
// - @jiModelingDynamicsRandom2026 (bezug zu DreamerV3)
//
// == Implementation
//
// - #text(gray)[Ray]
// - #text(gray)[RLLib]
// - #text(gray)[PyTorch]
// - #text(gray)[TorchRL]
