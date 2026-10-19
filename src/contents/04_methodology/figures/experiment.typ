#import "/src/deps.typ": cetz, fletcher
#import "symbols.typ"
#import "util.typ": symbol

#set text(size: 14pt)

#fletcher.diagram(
  node-stroke: 1pt,
  node-shape: fletcher.shapes.rect,
  node-inset: 8pt,
  spacing: (48pt, 24pt),
  label-sep: 0pt,
  label-size: 12pt,
  {
    import fletcher: edge, node
    // Sim block
    node((0, 0), name: "sim_learner_label", stroke: none)[Learner]
    node((0, 1), name: "sim_learner_traj")[#symbol(symbols.symbol_buffer)]
    edge("->")[optim]
    node((0, 2), name: "sim_learner_model")[#symbol(symbols.symbol_neural_net)]
    node(
      enclose: (<sim_learner_label>, <sim_learner_traj>, <sim_learner_model>),
      name: "sim_learner",
      shape: fletcher.shapes.house,
      stroke: 2pt + yellow,
    )

    node((1, 0), name: "sim_runner_label", stroke: none)[Runner]
    node((1, 1), name: "sim_runner_system")[#symbol(symbols.symbol_unity)]
    node((1, 2), name: "sim_runner_model")[#symbol(symbols.symbol_neural_net)]
    node(
      enclose: (<sim_runner_label>, <sim_runner_system>, <sim_runner_model>),
      name: "sim_runner",
      shape: fletcher.shapes.house,
      stroke: 2pt + blue,
    )
    edge(<sim_runner_system>, <sim_runner_model>, "<->")[explore]
    edge(<sim_runner_system>, <sim_learner_traj>, "->")[samples]
    edge(<sim_learner_model>, <sim_runner_model>, "->")[copy]

    node((0.5, -1), name: "sim_label", stroke: none)[Sim]
    node(
      enclose: (<sim_learner>, <sim_runner>, <sim_label>),
      stroke: 2pt,
      corner-radius: 8pt,
    )

    // Sim Model between Sim and Real
    node((2, 2), name: "sim_model")[
      #symbol(symbols.symbol_neural_net) \
      Sim Model
    ]

    // Real block
    node((3, 0), name: "real_learner_label", stroke: none)[Learner]
    node((3, 1), name: "real_learner_traj")[#symbol(symbols.symbol_buffer)]
    edge((3, 1), (3, 2), "->")[optim]
    node((3, 2), name: "real_learner_model")[#symbol(symbols.symbol_neural_net)]
    node(
      enclose: (<real_learner_label>, <real_learner_traj>, <real_learner_model>),
      name: "real_learner",
      shape: fletcher.shapes.house,
      stroke: 2pt + yellow,
    )

    node((4, 0), name: "real_runner_label", stroke: none)[Runner]
    node((4, 1), name: "real_runner_system")[#symbol(symbols.symbol_iso_square_rod)]
    node((4, 2), name: "real_runner_model")[#symbol(symbols.symbol_neural_net)]
    node(
      enclose: (<real_runner_label>, <real_runner_system>, <real_runner_model>),
      name: "real_runner",
      shape: fletcher.shapes.house,
      stroke: 2pt + blue,
    )
    edge(<real_runner_system>, <real_runner_model>, "<->")[explore]
    edge(<real_runner_system>, <real_learner_traj>, "->")[samples]
    edge(<real_learner_model>, <real_runner_model>, "->")[copy]

    node((3.5, -1), name: "real_label", stroke: none)[Fine-Tune]
    node(
      enclose: (<real_learner>, <real_runner>, <real_label>),
      stroke: 2pt,
      corner-radius: 8pt,
    )

    // Fine-tuned Model between Fine-Tune and Eval
    node((5, 2), name: "finetuned_model")[
      #symbol(symbols.symbol_neural_net) \
      Fine-Tuned Model
    ]

    // Eval block
    node((6, 0), name: "eval_runner_label", stroke: none)[Runner]
    node((6, 1), name: "eval_runner_system")[#symbol(symbols.symbol_iso_square_rod)]
    node((6, 2), name: "eval_runner_model")[#symbol(symbols.symbol_neural_net)]
    node(
      enclose: (<eval_runner_label>, <eval_runner_system>, <eval_runner_model>),
      name: "eval_runner",
      shape: fletcher.shapes.house,
      stroke: 2pt + blue,
    )
    edge(<eval_runner_system>, <eval_runner_model>, "<->")[infer]

    node((6, -1), name: "eval_label", stroke: none)[Eval]
    node(
      enclose: (<eval_runner>, <eval_label>),
      stroke: 2pt,
      corner-radius: 8pt,
    )

    // Connect sim and real via sim_model
    edge(<sim_runner_model>, <sim_model>, "->")
    edge(<sim_model>, <real_learner_model>, "->")

    // Connect real and eval via finetuned_model
    edge(<real_runner_model>, <finetuned_model>, "->")
    edge(<finetuned_model>, <eval_runner_model>, "->")

    // Metrics below each learner and runner
    // Sim Learner metrics (update)
    node((0, 3), name: "sim_learner_metrics")[
      #symbol(symbols.symbol_metrics) \
      update
    ]
    edge(<sim_learner>, <sim_learner_metrics>, "->")

    // Sim Runner metrics (step)
    node((1, 3), name: "sim_runner_metrics")[
      #symbol(symbols.symbol_metrics) \
      step
    ]
    edge(<sim_runner>, <sim_runner_metrics>, "->")

    // Real Learner metrics (update)
    node((3, 3), name: "real_learner_metrics")[
      #symbol(symbols.symbol_metrics) \
      update
    ]
    edge(<real_learner>, <real_learner_metrics>, "->")

    // Real Runner metrics (step)
    node((4, 3), name: "real_runner_metrics")[
      #symbol(symbols.symbol_metrics) \
      step
    ]
    edge(<real_runner>, <real_runner_metrics>, "->")

    // Eval Runner metrics (step)
    node((6, 3), name: "eval_runner_metrics")[
      #symbol(symbols.symbol_metrics) \
      step
    ]
    edge(<eval_runner>, <eval_runner_metrics>, "->")

    // Config above learners
    node((0, -3), name: "sim_learner_config")[
      #symbol(symbols.symbol_config) \
      config
    ]
    edge(<sim_learner_config>, <sim_learner>, "->")
    // Same config also feeds the real learner, routed below the blocks
    edge(
      <sim_learner_config>,
      "d",
      "r",
      "r",
      "r",
      <real_learner>,
      corner-radius: 8pt,
      marks: "->",
    )

    // Tuner next to the config
    node((1, -3), name: "tuner")[HPO]
    edge(<tuner>, <sim_learner_config>, "->")
    edge(
      <eval_runner_metrics>,
      "r",
      "u",
      "u",
      "u",
      "u",
      "u",
      "u",
      <tuner>,
      corner-radius: 8pt,
      marks: "->",
    )
  },
)
