#let _add_group(dict, group: "") = {
  dict.insert("group", group)
  return dict
}

#let _ml = (
  (
    key: "NN",
    short: "NN",
    long: "Neural Network",
  ),
  (
    key: "VAE",
    short: "VAE",
    long: "Variational Auto-Encoder",
  ),
)

#let _rl = (
  (
    key: "CR",
    short: "CR",
    long: "CyberRunner",
    description: "Ein Hardware- und Softwareprojkt, das mit Computer Vision und Reinforcement Learning das BRIO-Labyrinth spielt.",
  ),
  (
    key: "RL",
    short: "RL",
    long: "Reinforcement Learning",
  ),
  (
    key: "S2R",
    short: "S2R",
    long: "Sim-to-Real Transfer",
  ),
  (
    key: "MDP",
    short: "MDP",
    long: "Markov Decision Process",
  ),
  (
    key: "TD",
    short: "TD",
    long: "Temporal Difference",
  ),
  (
    key: "DP",
    short: "DP",
    long: "Dynamic Programming",
  ),
  (
    key: "PPO",
    short: "PPO",
    long: "Proximal Policy Optimization",
  ),
  (
    key: "MLAgents",
    short: none,
    long: "ML-Agents",
  ),
  (
    key: "Dreamer",
    short: none,
    long: "Dreamer",
  ),
)

#let glossary = (
  _rl.map(_add_group.with(group: "Reinforcement Learning")),
  _ml.map(_add_group.with(group: "Machine Learning")),
).flatten()
