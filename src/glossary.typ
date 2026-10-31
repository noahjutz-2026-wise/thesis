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
  DRL: (
    short: "DRL",
    long: "Deep Reinforcement Learning",
  ),
  DR: (
    short: "DR",
    long: "Domain Randomization",
  ),
  S2R: (
    short: "S2R",
    long: "Sim-to-Real Transfer",
  ),
  RG: (
    short: "RG",
    long: "reality gap",
  ),
  MDP: (
    short: "MDP",
    long: "Markov Decision Process",
  ),
  POMDP: (
    short: "POMDP",
    long: "Partially Observable Markov Decision Process",
  ),
  GPI: (
    short: "GPI",
    long: "Generalized Policy Improvement",
  ),
  GAE: (
    short: "GAE",
    long: "Generalized Advantage Estimation",
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
  MuJoCo: (
    short: "MuJoCo",
    long: "Multi-Joint dynamics with Contact",
  ),
  CoACD: (
    short: "CoACD",
  ),
)

#let _general = (
  IPC: (
    short: "IPC",
    long: "Inter-process Communication",
  ),
  CAD: (
    short: "CAD",
    long: "Computer-Aided Design",
  ),
  ROS: (
    short: "ROS",
    long: "Robot Operating System",
  ),
  SVG: (
    short: "SVG",
    long: "Scalable Vector Graphics",
  ),
)

#let glossary = (
  _rl.map(v => v + (group: "Reinforcement Learning")),
  _ml.map(v => v + (group: "Machine Learning")),
  _software.map(v => v + (group: "Tools, Libraries & Frameworks")),
  _general,
).join()

// Lets glossary references be written with a `gl:` prefix, e.g. @gl:RL.
// glossy's `show ref` handler splits the ref target on ":" and treats the
// first component as the key, so a raw `@gl:RL` would look up the key "gl"
// and fall through unstyled. This rule strips the prefix before glossy's
// rule (applied further out) sees the ref.
#let gl-refs(body) = {
  show ref: it => {
    let target = str(it.target)
    if target.starts-with("gl:") {
      let key = target.slice(3)
      if key != "" {
        return ref(label(key), supplement: it.supplement)
      }
    }
    it
  }
  body
}
