#let _add_group(dict, group) = {}


#let _ml = (
  NN: (
    short: "NN",
    long: "Neural Network",
  ),
  VAE: (
    short: "VAE",
    long: "Variational Auto-Encoder",
  ),
)

#let _rl = (
  CR: (
    short: "CR",
    long: "CyberRunner",
    description: "Ein Hardware- und Softwareprojkt, das mit Computer Vision und Reinforcement Learning das BRIO-Labyrinth spielt.",
  ),
  RL: (
    short: "RL",
    long: "Reinforcement Learning",
  ),
  S2R: (
    short: "S2R",
    long: "Sim-to-Real Transfer",
  ),
  MDP: (
    short: "MDP",
    long: "Markov Decision Process",
  ),
  TD: (
    short: "TD",
    long: "Temporal Difference",
  ),
  DP: (
    short: "DP",
    long: "Dynamic Programming",
  ),
  PPO: (
    short: "PPO",
    long: "Proximal Policy Optimization",
  ),
  MLAgents: (
    short: "ML-Agents",
  ),
  Dreamer: (
    short: "Dreamer",
  ),
)

#let glossary = (
  _rl.map(v => v + (group: "RL")) + _ml.map(v => v + (group: "ML"))
)
