= Task

The labyrinth game is an episodic, indefinite-horizon, partially observable, single-agent, stationary navigation task.


The reward function, observation space, action space, physical parameters, geometry, visual aspects, and dynamics shall be detailed here.

== Reward Function and Spaces

We reuse the reward function in @cyberrunner2. $N$ evenly spaced waypoints $upright(bold(w)) in RR^(2 times N)$ are laid out along the optimal path. At any given timestep $t$, the current progress $l$ is assigned to the index of the milestone, which is closest to the current ball position $bold(upright(b))_t in RR^2$ (@eq_waypoint).

$
  l_t = limits(arg min)_(i) norm(bold(upright(w))_i - bold(upright(b))_t)_2
$ <eq_waypoint>

The reward at $t$ is the difference between the progress at $t-1$ and $t$ (@eq_waypoint_diff).

$
  r(s) = Delta_l = l_t-l_(t-1)
$ <eq_waypoint_diff>

A defining feature in the @CR project is its ability to work with only a camera image and its derived features. Using markers on the rig and reference markers fixed in place, the plate pose and ball position are estimated. A 64 by 64 pixel greyscale subimage is attached to the observation. Finally, the next $N=5$ waypoints relative to the ball are provided.

As for the action space, a normalized continuous value in $[-1, 1]$ is passed for each of the two motors. By multiplying with a current value, we can tune the real-world motor speed this corresponds to.
