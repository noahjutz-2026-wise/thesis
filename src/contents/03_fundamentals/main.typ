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

// off-policy algorithm
// model-based / model-free
// ordinary / weighted importance sampling

(dynamics)

Fundamentals
- Approximation function @bartosutton

@DRL
- ?

Algorithms
- Monte Carlo
- N-Step TD
- TD(Lambda)
- @PPO @ppo @gae @suttonPolicyGradientMethods
- @DreamerV3, dyn-rec-pol loss, Imagination @dreamerv1 @dreamerv3

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
