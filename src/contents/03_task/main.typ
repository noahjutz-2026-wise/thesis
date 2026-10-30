= Task

The @CR variant of the labyrinth game, which we will be implementing, is an episodic, indefinite-horizon, partially observable, single-agent, stationary @RL task.

== Structure

The task fits neatly into the definition of an episodic task due to the mandatory reset after a marble falls into a hole or reaches the goal, but these two are not the only sufficient termination conditions, as it is also possible for an episode to end if the ball skips a section of the path. Lastly, if none of these conditions apply within a number of time steps, the episode will be truncated early.

While the labyrinth game is ideally stationary, we have found that when subjected to constant wear and tear due to high-speed motors performing movements that the rig was not laid out for during training, the wires start to fray, which may cause a shift in dynamics.

While @RL has been deployed in previous works to solve the generalized task of navigating a marble through a maze with holes @marble_maze, @CR and subsequently our work will focus on the single layout that is used on the BRIO Labyrinth Game. The policy will memorize the path and won't be applicable to other layouts. We therefore can't refer to the problem as a navigation task, as there is a predefined path to follow, and finding it is not part of the task.

== Reward Function

We reuse the reward function in @cyberrunner2. $N$ evenly spaced waypoints $upright(bold(w)) in RR^(2 times N)$ are laid out along the optimal path. At any given timestep $t$, the current progress $l$ is assigned to the index of the milestone, which is closest to the current ball position $bold(upright(b))_t in RR^2$ (@eq_waypoint).

$
  l_t = limits(arg min)_(i) norm(bold(upright(w))_i - bold(upright(b))_t)_2
$ <eq_waypoint>

The reward at $t$ is the difference between the progress at $t-1$ and $t$ (@eq_waypoint_diff).

$
  r(s) = Delta_l = l_t-l_(t-1)
$ <eq_waypoint_diff>

== Observation and Action Space

A defining feature in the @CR project is its ability to work with only a camera image and its derived features. Using markers on the rig and reference markers fixed in place, the plate pose and ball position are estimated. A 64 by 64 pixel greyscale subimage is attached to the observation. Finally, the next $N=5$ waypoints relative to the ball are provided.

(partial observability)

As for the action space, a normalized continuous value in $[-1, 1]$ is passed for each of the two motors. By multiplying with a current value, we can tune the real-world motor speed this corresponds to.
