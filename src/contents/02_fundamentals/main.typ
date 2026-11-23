= Theoretical Foundation

== @gl:RL:long

Originating from dynamic programming @bellmanDynamicProgramming1957, @gl:RL:both is an optimization technique for learning how to make good sequences of decisions through trial and error @bartosutton. Two entities take part in this process. The _agent_ is the decision maker that is being trained. The _environment_ is everything outside the agent that it can influence through its decisions and observe the consequences of, for example a simulated game or a physical robot with its surroundings. The agent's behavior is determined by its _policy_ $pi$, which is a function that, given the current situation, decides what the agent does next. Training means improving this policy based on the outcomes the agent experiences while interacting with the environment, without being told in advance which decisions are correct.

This interaction is formalized as a @gl:MDP, which proceeds in discrete _time steps_ $t = 0, 1, 2, ...$. In each step, the agent perceives the current _state_ $s$ of the environment, selects an _action_ $a$, and receives a numeric _reward_ $r$ that indicates how desirable the outcome was. The environment then transitions to a _subsequent state_ $s'$, and the cycle repeats. The following sections define these quantities in detail. The resulting sequence of alternating states, actions, and rewards is called a _trajectory_ and begins as shown in @eq:trajectory.

$
  S_0,A_0,R_1,S_1,A_1,R_2,S_2,A_2,R_3,...
$ <eq:trajectory>

The environment does not respond to the agent's actions deterministically: taking the same action in the same state may lead to different subsequent states and rewards. This stochastic behavior is captured by the _environment dynamics_, a probability distribution $p(s', r | s, a)$ over the _subsequent state_ $s'$ and the reward $r$ that follow from taking action $a$ in state $s$, as shown in @eq:dynamics.

$
  p(s', r | s, a) = Pr(S_t=s', R_t=r | S_(t-1)=s, A_(t-1)=a)
$ <eq:dynamics>

Together, the dynamics and the policy determine how likely a trajectory is. Since the agent chooses actions according to $pi(a|s)$ and the environment transitions according to the dynamics, the probability of a trajectory factorizes into one policy term and one transition term per step. Consider an episode that ends at the final time step $T$, starting from state $S_t$. The probability of the subsequent actions and states $A_t, S_(t+1), ..., S_T$ when the actions $A_(t:T-1)$ are selected according to $pi$ is given in @eq:trajectory_distribution @bartosutton. Here, $p(s'|s,a) = sum_r p(s', r|s, a)$ denotes the state-transition probability, obtained from the dynamics by marginalizing out the reward.

$
  & Pr(A_t, S_(t+1), A_(t+1), ..., S_T | S_t, A_(t:T-1) ~ pi) \
  & quad = pi(A_t | S_t) p(S_(t+1) | S_t, A_t) pi(A_(t+1)|S_(t+1)) ... p(S_T|S_(T-1), A_(T-1)) \
  & quad = product_(k=t)^(T-1) pi(A_k | S_k) p(S_(k+1) | S_k, A_k)
$ <eq:trajectory_distribution>

Tasks differ in how a trajectory ends. _Episodic_ tasks group steps into _episodes_, each of which ends in a _terminal state_, for example when a goal is reached, a failure occurs, or a time limit expires. After that, the environment is reset and a new episode begins. This is in opposition to _continuing_ tasks, which have no terminal state and go on indefinitely, as is the case for a controller that regulates a process around the clock.

The variables that define the situation of the environment at any given time are encapsulated within a number of numeric values, collectively comprising the _state_. The _state space_ $cal(S)$ is the set of all possible states the environment could find itself in. It may be finite in the case of simple environments such as Minigrid [CITATION NEEDED], where the state describes positions on a grid, or infinite when a variable is continuous, as is the case in real-world systems where quantities such as positions and velocities can take any real value.

A state fulfills the _Markov property_ if it contains all information from the past that is relevant for future decision making. In other words, knowing the history of earlier states and actions does not help predict what happens next any better than the current state alone. The decision process is then called Markovian, which is what the term @gl:MDP:long refers to. This requires that the agent can see every variable that is relevant for decision making, in which case the environment is _fully observable_. However, due to inaccuracies and delays in sensors, this is usually not the case in real-world systems. There, the agent does not receive the true state but only an _observation_, which may be noisy or lack some information. Such tasks belong to the class of @gl:POMDP:pl, in which the agent has to make decisions based on incomplete information.

The decision a policy has to make lies in choosing an appropriate _action_ $a$ at every time step. The _action space_ $cal(A)$ is the set of all actions the agent can choose from, and $cal(A)(s)$ denotes the actions that are available in a particular state $s$. Like the state space, the action space can be discrete (e.g. choosing a direction on a grid) or continuous (e.g. a motor target velocity).

In order to optimize the actions we take, we have to quantify their efficacy somehow. The primary mechanism for this is the _reward_, which is a scalar value the environment emits after each step. Since the goal in @gl:RL is to manipulate the environment in some desirable way, we design a _reward function_ $r(s, a, s')$ that maps a transition, i.e. taking action $a$ in state $s$ and ending up in state $s'$, to a reward that correlates with the desirability of this outcome. The agent always tries to maximize the reward, so good outcomes can be rewarded with a positive signal, and bad outcomes can be punished with a negative one.

The design of the reward function strongly influences how easily a policy can be trained. A reward function is _sparse_ when only few transitions lead to a significant positive or negative reward, for example when the agent is only rewarded upon reaching the goal. This makes it difficult for an agent to reliably tell which of its many preceding actions led to the reward. It is easier for a policy to converge if it is constantly fed rewards by a _dense_ reward function, which provides frequent feedback on progress. A good reward function bases its output on outcomes rather than methods, so that agents can develop potentially novel methods to solve a task optimally instead of being forced to imitate a prescribed one. Designing the reward function in this way is also called _reward shaping_.

It would be short-sighted to decide actions solely based on the immediate reward, since an action with a small immediate reward may enable large rewards later. That's why the goal in @gl:RL is to maximize the _return_ $G_t$, defined explicitly as the discounted sum of future rewards in @eq:return_sum. For finite-horizon tasks with terminal step $T$, the sum truncates at $T$, whereas for continuing tasks, an infinite horizon is used.

$
  G_t = sum_(k=0)^oo gamma^k R_(t+k+1)
$ <eq:return_sum>

Here, $0<=gamma<=1$ is the _discount rate_, which weighs immediate rewards more than distant ones to account for uncertainty and ensure finite values in continuing tasks. The return can also be expressed recursively as shown in @eq:discounted_return.

$
  G_t = R_(t+1) + gamma G_(t+1)
$ <eq:discounted_return>

The overall objective of reinforcement learning is to find a policy $pi$ that maximizes the expected return over full trajectories, formalized by the performance objective $J(pi)$ in @eq:rl_objective.

$
  J(pi) = EE_(tau ~ pi) [G_0]
$ <eq:rl_objective>

To decide which action is best, a policy needs a way to judge how promising a state or an action is in terms of expected return. The _state-value function_ $V_pi (s)$ defined in @eq:v_def represents the expected return when starting in state $s$ and following policy $pi$ thereafter.

$
  V_pi (s) = EE_pi [G_t | S_t = s]
$ <eq:v_def>

Likewise, the _action-value function_ $Q_pi (s, a)$ defined in @eq:q_def represents the expected return when taking action $a$ in state $s$ and following policy $pi$ thereafter.

$
  Q_pi (s, a) = EE_pi [G_t | S_t = s, A_t = a]
$ <eq:q_def>

By expanding $G_t$ recursively, the state-value function satisfies the _Bellman expectation equation_ shown in @eq:bellman_expectation.

$
  V_pi (s) = sum_(a in cal(A)) pi(a|s) sum_(s', r) p(s', r | s, a) [r + gamma V_pi (s')]
$ <eq:bellman_expectation>

The optimal policy $pi^*$ achieves the maximum expected return, corresponding to the optimal value functions $V^*(s) = max_pi V_pi (s)$ and $Q^*(s, a) = max_pi Q_pi (s, a)$. The optimal action-value function satisfies the _Bellman optimality equation_ shown in @eq:bellman_optimality.

$
  Q^*(s, a) = sum_(s', r) p(s', r | s, a) [r + gamma max_(a') Q^*(s', a')]
$ <eq:bellman_optimality>

From $Q^*$, the optimal deterministic policy is obtained greedily via $pi^*(s) = arg max_a Q^*(s, a)$. To isolate the relative quality of an action compared to the expected baseline in state $s$, we define the _advantage function_ $A_pi (s, a)$ in @eq:advantage.

$
  A_pi (s, a) = Q_pi (s, a) - V_pi (s)
$ <eq:advantage>

A positive advantage indicates that action $a$ yields a higher return than the average action chosen by $pi$.

As an example of how value estimates can be learned, consider tabular Monte Carlo control. _Tabular_ means that the state and action spaces are finite and small enough that one estimate can be stored for every state-action pair in a table. _Monte Carlo_ means that the estimates are computed from returns actually observed by sampling complete episodes, rather than from other estimates. _Control_ means that the goal is to find a good policy, as opposed to merely evaluating a given one. After each episode, the return $G_t$ that followed each visited state-action pair is used to nudge the corresponding table entry towards it, using the update rule in @eq:update_rule. Here, $alpha$ is the _learning rate_, which determines how much an estimate changes in a single update. If $alpha = 1/n$, where $n$ is the number of times the pair has been visited, the estimate is the _sample average_ of all returns observed for it.

$
  Q(s_t,a_t) <- Q(s_t, a_t) + alpha [G_t - Q(s_t, a_t)]
$ <eq:update_rule>

So far we have established how values can be estimated, but not how a policy can benefit from this calculation to improve over time. The process of making the estimates match #footnote[TODO "sampling the current policy"] the current policy is called _policy evaluation_, and the process of making the policy greedy with respect to the current estimates is called _policy improvement_. When iterating between collecting trajectories to update the estimates and acting on the updated estimates, this creates a moving target for both the policy and the estimator. As the estimate becomes more accurate, the policy becomes more informed in choosing actions, and as the policy changes its behavior accordingly, the estimate updates to reflect the new trajectories. This feedback loop is referred to as @gl:GPI.

Up to this point we have treated policies as _deterministic_, meaning that they always choose the same action in a given state, and greedy. This is rarely the case during training. Always choosing the action currently believed to be best is called _exploitation_. It can be detrimental for learning, since alternative pathways that could yield higher rewards are never tried. Trying actions or states that are unfamiliar in order to gather new information is called _exploration_, and balancing the two is known as the exploration-exploitation tradeoff. That is why we generally view policies as _stochastic_ functions that yield the probability of selecting an action given a state, written $pi(a|s)$. For example, an _epsilon-greedy_ policy with a parameter $0<=epsilon<=1$ chooses the greedy action with a probability of $1-epsilon+epsilon/abs(cal(A)(s))$, and any other action with a probability of $epsilon/abs(cal(A)(s))$. In effect, it picks a uniformly random action with probability $epsilon$ and the greedy action otherwise. Besides randomizing actions, methods exist to facilitate exploration by additionally rewarding the agent for visiting unseen states.

The randomness of a policy, which is measured by its _entropy_, is highest when all actions are equally likely and zero when it is deterministic. While a high entropy can be beneficial for exploration during training, it may be preferable to always exploit once the policy has been deployed. To do this, the _behavior policy_ of an algorithm, which is the policy used to collect experience during training, should differ from its _target policy_, which is the policy that is being learned and evaluated. We call this type of learning _off-policy_, as opposed to _on-policy_ learning, where both are the same. For example, an epsilon-greedy behavior policy used during training can be swapped out for a greedy target policy during inference.

Reinforcement learning algorithms differ in how they utilize environment dynamics $p(s', r | s, a)$. _Model-free_ algorithms learn value functions or policies directly from sampled transitions without explicitly modeling or relying on $p(s', r | s, a)$. In contrast, _model-based_ algorithms either assume known dynamics or explicitly construct an estimate of $p(s', r | s, a)$ to compute values or plan future decision sequences.

In summary, @gl:RL is all about learning a policy that takes a state as input and provides actions as output, in order to maximize the expected return, which is the cumulative, possibly discounted, reward. An episode consists of a trajectory of alternating states, actions, and rewards, which begins as seen in @eq:trajectory. Important considerations aside from algorithm implementation details are observability, reward design, and the exploration-exploitation tradeoff.

== Function Approximation in Reinforcement Learning <sec:function-approximation>

In environments with large or continuous state spaces, tabular representations, which store one value estimate per state or state-action pair, are impractical: such a table cannot enumerate an infinite set of states, and it cannot generalize from visited to unvisited states. Algorithms therefore rely on _function approximation_, in which policies and value functions are represented by parameterized functions. For example, the state-value function can be approximated with a weight vector $bold(w)$, denoted as $hat(v)(s, bold(w))$. Neural networks are a particularly expressive class of such approximators, since they can represent mappings from states to actions as well as to value estimates.

To train this approximate value function, we must define an objective to minimize, known as a loss function. Because we are trying to predict a continuous numeric value -- the expected return -- we use a regression loss. A common choice is the mean squared value error shown in @eq:value_error, which minimizes the expected squared difference between the network's approximation and a chosen target return $G_t$.

$
  L(bold(w)) = EE[(hat(v)(S_t, bold(w)) - G_t)^2]
$ <eq:value_error>

The simplest choice for the target $G_t$ is the actual return sampled from a complete episode, an approach known as Monte Carlo. However, Monte Carlo targets suffer from high variance because they accumulate the randomness of many transitions over a full episode. We can improve upon this by using a one-step @gl:TD target. Instead of waiting until the end of the episode to compute the exact return, a one-step @gl:TD method truncates the sum after the first immediate reward and substitutes the remainder of the trajectory with its own current estimate of the next state's value, $hat(v)(S_(t+1), bold(w))$. The practice of updating a learned estimate based on another learned estimate, rather than waiting for a final outcome, is called bootstrapping.

The discrepancy between this bootstrapped one-step @gl:TD target and the current value estimate $hat(v)(S_t, bold(w))$ is called the @gl:TD error $delta_t$, defined in @eq:td_error. It quantifies the surprise of a single transition.

$
  delta_t = R_(t+1) + gamma hat(v)(S_(t+1), bold(w)) - hat(v)(S_t, bold(w))
$ <eq:td_error>

By generalizing between full Monte Carlo returns and one-step @gl:TD targets, we can define the $n$-step return, which accumulates $n$ actual rewards before bootstrapping from the approximate value of the $n$-th subsequent state. To balance the high variance of Monte Carlo and the high bias of one-step @gl:TD across different horizon lengths, @gl:GAE:long computes an exponentially weighted average of these $n$-step returns using a decay parameter $lambda$. The resulting @gl:GAE advantage estimate $hat(A)_t^"GAE"$ is defined in @eq:gae.

$
  hat(A)_t^"GAE" = sum_(l=0)^oo (gamma lambda)^l delta_(t+l)
$ <eq:gae>

== @gl:DRL:long

@gl:DRL:long refers to reinforcement learning in which the approximators described in @sec:function-approximation are realized with deep neural networks, a class of parametrized functions that can also represent environment models. In supervised learning, labeled data are available: the network output is compared with the true label, a loss function quantifies the discrepancy, the gradient of this loss with respect to the network parameters is computed via backpropagation, and the parameters are updated using optimization methods such as stochastic gradient descent.

In @gl:RL, no labeled data are available. The learning signal is the reward received through interaction with the environment, so training targets must be constructed from the agent’s own experience, for example from sampled returns or from estimates of future reward produced by the network itself. Consequently, the data distribution depends on the current behavior of the agent and changes as learning progresses, in contrast to the fixed dataset assumed in supervised learning.

Two function approximators are central to the algorithms considered in this thesis. The policy (or actor) maps a state to a probability distribution over actions. The value function (or critic) estimates the expected future return from a given state and thus evaluates how good the current situation is under the policy. Methods that learn both are called actor-critic methods: the critic’s estimate is used to judge whether an action performed better or worse than expected, and the actor is adjusted accordingly. This corresponds to @gl:GPI, where the critic carries out policy evaluation and the actor carries out policy improvement via gradient updates instead of greedy maximization, which is impractical for continuous actions. Both @gl:PPO @ppo and @gl:DreamerV3 @dreamerv3 belong to this family and differ mainly in the data from which actor and critic are trained.

@gl:PPO is a model-free actor-critic algorithm. It collects a batch of trajectories with the current policy in the environment and uses it to update the actor and critic networks. A central difficulty of policy-based methods is that an overly large update can degrade the policy and, because new data are collected with this policy, hinder recovery. @gl:PPO addresses this by comparing the probability of an action under the updated policy parameterized by $bold(theta)$ to its probability under the old policy parameterized by $bold(theta)_"old"$ that collected the data. The ratio is one at the old parameters, $r(bold(theta)_"old") = 1$, and is expressed as the probability ratio $r_t (bold(theta))$ in @eq:ppo_ratio @ppo.

$
  r_t (bold(theta)) = (pi_bold(theta) (a_t | s_t)) / (pi_(bold(theta)_"old") (a_t | s_t))
$ <eq:ppo_ratio>

Before any clipping, @gl:PPO maximizes the conservative policy iteration objective $L^"CPI" (bold(theta))$ in @eq:ppo_cpi, which weights the ratio by the advantage estimate so that actions that fare better than the critic's expectation become more likely @ppo.

$
  L^"CPI" (bold(theta)) = EE_t [r_t (bold(theta)) hat(A)_t]
$ <eq:ppo_cpi>

To prevent destructively large policy updates, @gl:PPO instead clips the ratio to a small interval $[1-epsilon, 1+epsilon]$ around one. The clipped surrogate objective $L^"CLIP" (bold(theta))$ is defined in @eq:ppo_clip, which scales the ratio by the advantage estimate $hat(A)_t$, obtained with @gl:GAE as in @eq:gae. Because the minimum selects the clipped term whenever the ratio leaves the interval, a gradient contribution arises only from updates that remain close to the data-collecting policy.

$
  L^"CLIP" (bold(theta)) = EE_t ["min"(r_t (bold(theta)) hat(A)_t, "clip"(r_t (bold(theta)), 1-epsilon, 1+epsilon) hat(A)_t)]
$ <eq:ppo_clip>

This promotes stable learning and allows multiple gradient updates on the same batch, which improves data usage compared to a single update per batch.

// In addition to the policy objective, @gl:PPO simultaneously optimizes the state-value function $hat(v)(s, bold(w))$ using a squared-error loss $L^"VF" (bold(w))$ similar to @eq:value_error. To encourage exploration, an entropy bonus $S(pi_bold(theta) (s_t))$ is added. The total objective maximized during training combines these three components, as shown in @eq:ppo_total, where $c_1$ and $c_2$ are coefficients.
//
// $
//   L^"TOTAL" (bold(theta), bold(w)) = EE_t [L^"CLIP" (bold(theta)) - c_1 L^"VF" (bold(w)) + c_2 S(pi_bold(theta) (s_t))]
// $ <eq:ppo_total>
//
// For continuous actions, the actor outputs the parameters of a probability distribution over actions, from which actions are sampled during training.

@gl:DreamerV3 is a model-based actor-critic algorithm @dreamerv3. Instead of learning solely from real environment interaction, it learns a world model, parameterized by $Phi$, to simulate the environment in a compact latent space. The core of this world model is the Recurrent State-Space Model (RSSM) @dreamerv1, which maintains a deterministic sequence state $h_t$ and a stochastic discrete latent state $z_t$; together they form the model state $s_t = (h_t, z_t)$. The world model consists of the six components summarized in @eq:dreamer_components @dreamerv3. The encoder maps the input $x_t$ to a categorical distribution from which the latent state $z_t$ is drawn. The sequence model carries $h_t$ forward through the previous latent state and action, which allows the dynamics predictor to roll the latent state forward on its own, predicting $hat(z)_t$ without seeing any input. Rolling these two components forward from an encoded state therefore yields imagined trajectories that never touch the environment: the actor learns from the rewards $hat(r)_t$ and continuation flags $hat(c)_t$ predicted along them, while the decoder keeps the latent space informative by reconstructing the input as $hat(x)_t$ @dreamerv3.

$
      "Sequence model:" & h_t = f_Phi (h_(t-1), z_(t-1), a_(t-1)) \
             "Encoder:" & z_t tilde.op q_Phi (z_t | h_t, x_t) \
  "Dynamics predictor:" & hat(z)_t tilde.op p_Phi (hat(z)_t | h_t) \
    "Reward predictor:" & hat(r)_t tilde.op p_Phi (hat(r)_t | h_t, z_t) \
  "Continue predictor:" & hat(c)_t tilde.op p_Phi (hat(c)_t | h_t, z_t) \
             "Decoder:" & hat(x)_t tilde.op p_Phi (hat(x)_t | h_t, z_t)
$ <eq:dreamer_components>

Training presents the world model with sequences of $T$ inputs $x_(1:T)$, together with the actions $a_(1:T)$ taken in them and the rewards $r_(1:T)$ and continuation flags $c_(1:T)$ they produced. All components are then updated jointly by minimizing the three losses combined in @eq:dreamer_loss, weighted by $beta_"pred" = 1$, $beta_"dyn" = 1$, and $beta_"rep" = 0.1$ @dreamerv3.

$
  cal(L)(Phi) eq.dot EE_(q_Phi) [sum_(t=1)^T (beta_"pred" cal(L)_"pred" (Phi) + beta_"dyn" cal(L)_"dyn" (Phi) + beta_"rep" cal(L)_"rep" (Phi))]
$ <eq:dreamer_loss>

The three losses are defined in @eq:dreamer_losses. The prediction loss scores how closely the decoder, the reward predictor, and the continuation predictor reproduce their respective targets, using a symlog squared loss for the first two and logistic regression for the last. Both KL terms penalize the Kullback-Leibler (KL) divergence between the dynamics predictor $p_Phi (z_t | h_t)$ and the encoder $q_Phi (z_t | h_t, x_t)$, but they pull in opposite directions: the stop-gradient operator $"sg" (dot)$ cuts the gradient path through one side of each divergence, so $cal(L)_"dyn"$ adjusts the dynamics predictor towards the representation, whereas $cal(L)_"rep"$ adjusts the representation towards the dynamics prediction. The surrounding $max(1, dot)$ lets each KL term vanish as soon as its divergence falls below one nat, so that a well-matched dynamics predictor does not dominate the gradient budget @dreamerv3.

$
  cal(L)_"pred" (Phi) & = - ln p_Phi (x_t | z_t, h_t) - ln p_Phi (r_t | z_t, h_t) - ln p_Phi (c_t | z_t, h_t) \
   cal(L)_"dyn" (Phi) & = "max"(1, "KL"["sg"(q_Phi (z_t | h_t, x_t)) || p_Phi (z_t | h_t)]) \
   cal(L)_"rep" (Phi) & = "max"(1, "KL"[q_Phi (z_t | h_t, x_t) || "sg"(p_Phi (z_t | h_t))])
$ <eq:dreamer_losses>

The algorithm then trains an actor network parameterized by $theta$ and a critic network parameterized by $psi$ on trajectories imagined entirely in this latent space. These trajectories are generated by the dynamics model and the predictors, starting from states encountered in real experience. Because imagined trajectories can be generated at no cost to the real environment, @gl:DreamerV3 requires considerably fewer real interactions than model-free methods. However, the approach depends on the accuracy of the learned world model: errors in the model can compound and mislead the actor $pi_theta$ and critic $hat(v)_psi$.

Despite these differences, @gl:PPO and @gl:DreamerV3 share a training structure in which data collection and parameter updates are decoupled. Instead of updating the networks on each transition as it arrives, both algorithms first gather experience and then perform multiple gradient updates on randomly drawn minibatches, which reduces the correlation between consecutive samples and allows the same data to be used repeatedly.

// Algorithms
// - Monte Carlo
// - N-Step TD
// - TD(Lambda)

== @gl:S2R:long

@gl:S2R refers to training a policy in a simulated environment, the source domain, and deploying it on the physical system, the target domain, where it is expected to solve the task. Because a simulator is only an approximation of the physical system, the two domains differ. The resulting discrepancy between simulated and real performance of a policy is called the @gl:RG @salvatoCrossingRealityGap2021. Following @zhaoSimtoRealTransferDeep2020a, two sources can be distinguished. The first concerns the observations: images or sensor readings produced by the simulator differ from those of real sensors, so the policy receives inputs it has not seen during training. The second concerns the dynamics: the physical system responds differently to the same action than the simulator predicts, for example due to inaccurately modeled masses, friction, or actuators. A policy can fail in the target domain because of either source.

Among the most common techniques in @gl:S2R are System Identification, @gl:DR, Domain Adaptation and Imitation Learning @zhaoSimtoRealTransferDeep2020a.

_System Identification_ is the process of creating an idealized mathematical model for sensors and actuators that approximately replicates the behavior of the real system.

_#[@gl:DR]_ can be applied to visuals and dynamics. Altering textures and lighting during training can robustify the policy agains these perturbations during inference. As it pertains to dynamics randomization, dimensions, masses and friction coefficients are examples for targets of randomization.

== Dynamics

- Rigidbody joint underactuated robotics mechanical systems

== @CV:long

A pipeline for estimating the ball position on the labyrinth board using @CV is described in @bergattMinimierungUndUntersuchung[pp. 57 - 75], however there is no indication of the source code having been made publicly available. On the other hand, @cyberrunner doesn't describe their implementation but provides their source code, including their @CV pipeline, under a free and open-source license. After evaluating both sources, we can summarize their main contributions.

=== Camera Intrinsics

Both utilize the @OpenCV library, which contains reference implementations of various @CV algorithms. Our wide-angle fisheye camera has the advantage of a wider field of view, and therefore does not need to be mounted as far from the board to get a full view. However, this leads to parallel lines no longer appearing parallel, as can be seen in @fig:lensdistort.barrel.

#include "figures/dist_coeff.typ"

To remove this radial warping, the camera's intrinsic parameters are calibrated using a checkerboard pattern. In the @OpenCV fisheye model, these parameters consist of the camera matrix $K$ (which maps 3D camera rays to 2D pixel coordinates using focal length and optical center) and four distortion coefficients $D = (k_1, k_2, k_3, k_4)$.

Consider a 3D point $(X, Y, Z)$ in front of the camera. Projecting it onto a flat plane at unit depth ($Z = 1$) gives ideal, undistorted coordinates $bold(v) = (x, y)^T = (X\/Z, Y\/Z)^T$ at radial distance $r = sqrt(x^2 + y^2)$ from the center. Because this plane sits at depth $1$, the incoming light ray forms a right triangle with angle $theta = arctan(r)$ relative to the optical axis, as illustrated in @fig:raygeometry.
#figure(
  caption: [
    Geometry of the fisheye projection model. A point on the unit-depth
    plane at radial distance $r$ from the optical center is seen by the
    lens under the angle $theta = arctan(r)$ relative to the optical axis.
  ],
)[
  #include "figures/ray_geometry.typ"
] <fig:raygeometry>

A physical fisheye lens bends this ray to a distorted angle $theta_d$, modeled by a 9th-degree odd polynomial:

$
  theta_d = theta (1 + k_1 theta^2 + k_2 theta^4 + k_3 theta^6 + k_4 theta^8)
$

Since radial distortion pushes or pulls points straight along lines radiating from the optical center without rotating them, the distorted plane coordinates $bold(v)'$ are obtained by scaling $bold(v)$ from radius $r$ to radius $theta_d$:

$
  bold(v)' = (theta_d / r) bold(v)
$

Finally, multiplying $bold(v)'$ by the camera matrix $K$ yields the exact pixel location in the raw fisheye image. To generate an undistorted output frame, @OpenCV loops over every target pixel in the clean output grid, maps it backward through $K^(-1)$ onto the unit-depth plane, applies the forward distortion equations above, and samples the corresponding pixel color from the raw fisheye image via bilinear interpolation.

=== @gl:PnP:long

Before the ball's position can be estimated, the pipeline needs to know how the board is tilted relative to the camera. This is recovered with @gl:PnP, which solves the following problem: given $n$ 3D points whose coordinates are known in the board's own frame, and their 2D pixel positions observed in the image, find the board pose -- a rotation $bold(R)$ and translation $bold(t)$ -- that projects each 3D point exactly onto its observed pixel, as illustrated in @fig:pnp. Because the board is fitted with marker dots whose positions are known from construction, detecting them in each frame and solving @gl:PnP yields the board's tilt for that frame.

#include "figures/pnp.typ"

=== Homography

A _homography_ is a projective transformation, represented by a $3 times 3$ matrix $bold(H)$, that maps points between two planes: for every flat surface there exists a homography that relates positions on that surface to pixel positions in its image. Since the board is planar, the pose recovered by @gl:PnP determines the homography between the board plane and the image.

We plan to use this to find the ball's position, as illustrated in @fig:homography. The ball's detected pixel $bold(u)$ fixes a single viewing ray through the optical center, and the intersection of this ray with the tilted board plane is the ball's position $bold(b)$ on the board. In other words, the ball's pixel is mapped through $bold(H)^(-1)$ onto the board plane, which yields its position in board coordinates directly.

#include "figures/homography.typ"
