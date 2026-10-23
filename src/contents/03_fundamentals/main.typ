= Theoretical Foundation

== @RL:long

Originating from dynamic programming @bellmanDynamicProgramming1957, @RL:both is an optimization technique wherein a _policy_ $pi$, which makes a sequence of decisions, is trained via trial and error @bartosutton. This is achieved by an agent which interacts with an environment through a series of @MDP:pl. Such a process consists of discretized time steps. _Episodic_ tasks group steps into episodes, which can end after a time limit or some event. This is in opposition to _continuing_ tasks, which have no terminal state. Each step is associated with a state $s$, action $a$, reward $r$, and subsequent state $s'$.

The variables that define a system at any given time are encapsulated within a number of numeric variables, collectively comprising the _state_. The _state space_ $cal(S)$ encompasses all possible states the environment could find itself in. It may be finite in the case of simple environments such as Minigrid [CITATION NEEDED], or infinite when a variable is continuous, as is the case in real-world systems. When every variable that is relevant to decision-making is avilable, the environment is _fully observable_. However, due to inaccuracies and delays in sensors, this is usually not the case in real-world systems. They therefore belong to the class of @POMDP:pl. A state fulfills the _Markov property_ if it contains all past state information that is relevant for future decision making.

The decision a policy has to make lies in choosing an appropriate _action_ $a$ at every timestep. Again, the _action space_ $cal(A)$ can be discrete (e.g. choosing a direction on a grid) or continuous (e.g. motor target velocity).

In order to optimize the actions we take, we have to quantify their efficacy somehow. The primary mechanism for this is the _reward_, which is a scalar value derived from the state. Since the goal in @RL is to manipulate the environment in some desirable way, we want to design our _reward function_ $r(s, a, s')$ so that it yields values that correlate with the desirability of the resulting state. A policy always tries to maximize the reward, so good states can be rewarded with a positive signal, and bad states can be punished with a negative one. A reward function is _sparse_ when only few states lead to a significant positive or negative reward, which makes it difficult for an agent to reliably tell which action led to the reward. It is easier for a policy to converge if it is constantly fed rewards by a _dense_ reward function. A good reward function bases its output on outcomes rather than methods, so that agents can develop potentially novel methods to solve a task optimally. Furthermore, methods exist to facilitate exploration by rewarding unseen states.

It would be short-sighted to decide actions solely based on the immediate reward. That's why the goal in @RL is to maximize the _expected return_, which is an aggregate of future rewards. In addition to simply averaging them, we can apply a _discount rate_ $0<=gamma<=1$ which causes immediate rewards to be weighed more. This is not only a good way to hedge uncertainty about the future, but necessary to keep returns finite in continuing tasks. It can be computed recursively as shown in @eq_discounted_return.

$
  G_t = R_(t+1) + gamma G_(t+1)
$ <eq_discounted_return>

Value-based methods revolve around the idea of estimating the value $V(s)$ of each state, so that a greedy policy selects the action that leads to the best state. Mapping state-action pairs to value estimates $Q(s, a)$ allows for a greedy policy to select $pi(s) = arg max_a Q(s, a)$ in any state. In tabular Monte Carlo control, for instance, the estimate for each discrete state-action pair is incrementally computed by using the update rule in @eq_update_rule, where $alpha$ is the _learning rate_ and determines how much the policy changes in a single update. If $alpha = 1/n$ with $n$ steps, this is the _sample average_.

$
  Q(s_t,a_t) <- Q(s_t, a_t) + alpha [G_t - Q(s_t, a_t)]
$ <eq_update_rule>

So far we have established how values can be estimated, but not how a policy can benefit from this calculation to improve over time. After a policy chooses an action according to its estimated value, the experienced trajectory is used to update the estimates as per @eq_update_rule, making them more accurate. When iterating between collecting samples and updating value estimates, this creates a moving target for both the policy and the estimator: As the estimate becomes more accurate, the policy becomes more informed on choosing actions, and as the policy changes its behavior accordingly, the estimate updates to reflect new trajectories. This feedback loop is referred to as @GPI.

So far we have treated policies as deterministic and greedy, but this is rarely the case during training. Always exploiting the perceived optimal action can be detrimental for learning, since alternative pathways that could yield higher rewards are never explored. That's why we generally view policies as stochastic functions that yield the probability of selecting an action given a state $pi(a|s)$. For example, an epsilon-greedy policy chooses the greedy action with a probability of $1-epsilon+epsilon/abs(cal(A)(s))$, and any other action with a probability of $epsilon/abs(cal(A)(s))$.

While increasing entropy during training can be benefitial for exploration, it may be preferable to always exploit once the model has been deployed. To do this, the _behavior policy_ of an algorithm during training should differ from from its _target policy_. We call this type of learning _off-policy_. For example, an epsilon-greedy behavior policy during training can be swapped out for a greedy target policy during inference.

Finally, another stochastic aspect of @MDP:pl that must be taken into account is the potentially non-deterministic impact an action has on the environment. We call this the _dynamics_, shown in @eq_dynamics. If the dynamics are known, the training algorithm is said to be _model-based_. Otherwise, it is said to be _model-free_.

$
  p(s', r | s, a) = Pr(S_t=s', R_t=r | S_(t-1)=s, A_(t-1)=a)
$ <eq_dynamics>

In summary, @RL is all about learning a policy that takes a state as input and provides actions as output, in order to maximize a cumulative reward. An episode consists of trajectories of alternating states, actions, and rewards, which begins as seen in @eq_trajectory. Important considerations aside from algorithm implementation details are observability, reward shaping, and exploration-exploitation tradeoff.

$
  S_0,A_0,R_1,S_1,A_1,R_2,S_2,A_2,R_3,...
$ <eq_trajectory>

== @DRL:long

In cases where the state and action spaces are continuous, a value-based tabular policy that discretely maps state-action pairs to value estimates is impossible. Thus, approximation methods are used in the algorithms we utilize. Neural networks can encode mappings from states to actions. In supervised learning, where labeled data is available, the network output is compared to the true label, the resulting loss backpropagated, and parameters optimized through methods such as stochastic gradient descent.

(Actor-Critic)

(PPO)

(DreamerV3)

// Algorithms
// - Monte Carlo
// - N-Step TD
// - TD(Lambda)

== @S2R:long

- Physics
  - Inertial spherical movement in gravity
  - Friction
  - Approximations
- Timing
  - Sensor + actuator delays
- Methods
  - Domain Randomization
  - Domain Adaptation

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

== Labyrinth Game Parameters

The labyrinth game is an episodic, indefinite-horizon, partially observable, single-agent, stationary navigation task.


The reward function, observation space, action space, physical parameters, geometry, visual aspects, and dynamics shall be detailed here.

=== Reward Function

We reuse the reward function in @cyberrunner2. $N$ evenly spaced waypoints $upright(bold(w)) in RR^(2 times N)$ are laid out along the optimal path. At any given timestep $t$, the current progress $l$ is assigned to the index of the milestone, which is closest to the current ball position $bold(upright(b))_t in RR^2$ (@eq_waypoint).

$
  l_t = limits(arg min)_(i) norm(bold(upright(w))_i - bold(upright(b))_t)_2
$ <eq_waypoint>

The reward at $t$ is the difference between the progress at $t-1$ and $t$ (@eq_waypoint_diff).

$
  r(s) = Delta_l = l_t-l_(t-1)
$ <eq_waypoint_diff>

=== Observation Space

A defining feature in the @CR project is its ability to work with only a camera image and its derived features. Using markers on the rig and reference markers fixed in place, the plate pose and ball position are estimated.
