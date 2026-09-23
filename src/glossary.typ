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
  ),
  MM: (
    short: "marble-maze",
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
  DreamerV3: (
    short: "DreamerV3",
  ),
)

#let _software = (
  MLAgents: (
    short: "ML-Agents",
  ),
  Ray: (
    short: "Ray",
  ),
  WandB: (
    short: "WandB",
    long: "Weights & Biases",
  ),
)

#let _general = (
  IPC: (
    short: "IPC",
    long: "Inter-process Communication",
  ),
)

#let glossary = (
  _rl.map(v => v + (group: "Reinforcement Learning")),
  _ml.map(v => v + (group: "Machine Learning")),
  _software.map(v => v + (group: "Tools, Libraries & Frameworks")),
  _general,
).join()
