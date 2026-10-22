#import "/src/deps.typ": cetz, fletcher
#import "/src/common/symbols.typ"
#import "/src/common/util.typ": symbol, uml-component

#set text(size: 6.5pt)

#let component(body, name: [component]) = uml-component(
  body,
  name: name,
  symb: symbol(symbols.symbol_module, canvas-size: auto, symbol-size: 7pt),
)

#fletcher.MARKS.update(m => (
  m
    + (
      "Oc": (inherit: "O", tip-origin: 0, tail-origin: 0),
      "(c": (inherit: "(", tip-origin: 0, tail-origin: 0),
      ")c": (inherit: ")", tip-origin: 0, tail-origin: 0),
      "|>h": (inherit: "latex", fill: none, stroke: 0.6pt),
    )
))

#fletcher.diagram(
  node-stroke: 0.6pt,
  node-inset: 3pt,
  spacing: (4pt, 6pt),
  label-size: 6pt,
  mark-scale: 70%,
  {
    import fletcher: edge, node

    node(enclose: ((-1, 0), (0, 0)), name: "algo_label")[#component[Algorithm]]
    node(enclose: ((-1, 3), (-1, 5)), name: "learner_label", stroke: yellow)[#component[Learner]]
    node(enclose: ((0, 3), (0, 5)), name: "rs_label", stroke: blue)[#component[EnvRunnerServer]]
    node(enclose: ((3, 3), (3, 5)), name: "rc_label")[#component[EnvRunnerClient]]
    node(enclose: ((6, 3), (6, 5)), name: "env_base")[#component[env-base]]

    node((7, 3), name: "env_sim")[#component[env-unity]]
    node((7, 5), name: "env_real")[#component[env-cr]]
    node((10, 3), name: "backend_sim")[#component[backend-unity]]
    node((10, 5), name: "backend_real")[#component[backend-cr]]

    edge((-1, 0), "d", "-(")
    edge((0, 0), "d", "-(")
    edge((-1, 3), "u", "-O")
    edge((0, 3), "u", "-O")
    edge((-1, 2), "u", "<--", stroke: gray)
    edge((0, 2), "u", "<--", stroke: gray)

    edge((0, 5), "r", "-(")
    edge((1, 5), "r", "-->", stroke: gray)
    edge((2, 5), "r", "O-")

    edge((0, 3), "r", "-O")
    edge((1, 3), "r", "<--", stroke: gray)
    edge((2, 3), "r", ")-")

    edge((3, 4), "r", "-(")
    edge((4, 4), "r", "-->", stroke: gray)
    edge((5, 4), "r", "O-")

    edge(<env_sim>, <env_base>, "-|>h")
    edge(<env_real>, <env_base>, "-|>h")

    edge((7, 5), "r", "-(")
    edge((8, 5), "r", "-->", stroke: gray)
    edge((9, 5), "r", "O-")

    edge((7, 3), "r", "-O")
    edge((8, 3), "r", "<--", stroke: gray)
    edge((9, 3), "r", ")-")
  },
)
