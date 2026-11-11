= Conclusion

- Summary
- Limitations
- Implications
- Future work

== Future Research

// - Impact of scaling on sample count and performance
//   - *Learner Parallelization:* Using Ray Core
//   - *Sim GPU Accel:* Using BRAX, MJX, SKRL, ...
// - @gl:RL Methods that were omitted
//   - *Curriculum Learning:* Currently a fixed maze is learned, rather than the process of solving a maze. Randomizing in simulation is easy.
//   - *Random starts:* initial random ball position
//   - *Hyperparameter Optimization*: Using Ray Tune
// - @gl:S2R Methods that were omitted
//   - *Behavior Cloning*: Fixed policy determined through physical parameters
//   - *System Identification:* Ascertain exact friction coefficients, motor acceleration, etc.
//   - *R2S2R:* (?)
//   - *Different transfers:* R2S, S2S, R2R

Due to our contribution of a gymnasium environment for the BRIO Labyrinth both for the physical rig by @cyberrunner[a:] and a simulation of it using @MuJoCo, the game can be used as a testbed for future @RL experiments of various natures. Future research might be focused on the performance of different @RL methods, @S2R methods and relevant control parameters. Furthermore, the modular setup allows for swapping out frameworks and algorithms, enabling research on computation efficiency and @RL algorithms.

=== Computational optimizations

Our experiments were run on a single machine with one GPU, which was used for learning and 32 CPUs, on which simulation inference was executed. We used Ray @ray @rllib to parallelize environment runners. It is unknown to what extent parallelization of the simulation environment sped up sample collection, and what the overhead may have been. In addition, we didn't explore distributing the compute cost of learning across multiple GPUs or nodes. Due to our use of the Ray ecosystem in our experiment pipeline, it could be expanded to look further into these computational questions.

We don't know the possibilities and limitations of GPU-Accelerated simulation inference using runtimes such as @MuJoCo Playground @mujoco_playground_2026, which could yield a far higher rate of parallelization than our CPU-based parallelization. Since the @MuJoCo engine was rewritten to be able to be run on a GPU in @MuJoCo Warp @GoogledeepmindMujoco_warp2026 #footnote[TODO fix MJWarp citation], our backend can likely be trivially ported to run on GPU. Aside from researching the impacts of these optimizations, the purported benefits could allow for evaluating policies trained on larger sample data.

=== @RL:long methods

This thesis was focused on solving the fixed maze labyrinth that can be found in contemporarily manufactured BRIO labyrinths. Therefore, we made design decisions that incapacitate our policy from generalizing to be able to solve arbitrary layouts. For example, the reward and target direction vector are calculated by comparing the ball position to a hardcoded path, as is the case in @cyberrunner. @marble_maze[as:] Unity simulation of the labyrinth game overcomes such limitations by the use of a shortest paths algorithm. Further, their observations include raycasts to walls (@tbl:unity_cr_spaces), which may allow the policy to generalize to different wall layouts. Crucially, they also provide the @SVG Level importer, facilitating the creation of heterogenous training environments. However, their implementation requires full observability of the mesh that defines the maze, which inhibits transferability to the real world, when only a camera image is available. Beyond that, their environment's dynamics are difficult to tune toward a realistic one #footnote[TODO prove this]. Our work provides an alternative base for researchers looking to achieve this:
