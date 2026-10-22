#import "/src/deps.typ": cetz
#import "/src/common/symbols.typ"
#import "/src/common/util.typ": symbol

#let sym(s) = symbol(s, canvas-size: 0.55cm, symbol-size: 0.55cm)

#cetz.canvas(length: 1cm, {
  import cetz.draw: *

  let pad = 8pt
  // horizontal timeline arrow of length 7 with straight mark
  line((-pad, 0), (7 + pad / 1cm, 0), mark: (end: "straight", fill: black))

  // 7 ticks (at x = 0, 1, 2, 3, 4, 5, 6)
  for i in range(7) {
    line((i, -3pt), (i, 3pt))
  }
  content((0, -12pt), padding: 3pt)[$t - n$]
  content((3, -12pt), padding: 3pt)[$t$]

  // contents with inset
  content((0, 1), name: "obs", padding: 6pt)[
    #stack(
      spacing: 4pt,
      sym(symbols.symbol_image),
      [obs],
    )
  ]
  content((3, 1), name: "step", padding: 6pt)[step(a)]
  content((6, 1), name: "act", padding: 6pt)[act]

  // upwards facing arrows: gray and dashed, straight mark
  line((0, 0), "obs.south", mark: (end: "straight"), stroke: (paint: gray, dash: "dashed"))
  line((3, 0), "step.south", mark: (end: "straight"), stroke: (paint: gray, dash: "dashed"))
  line((6, 0), "act.south", mark: (end: "straight"), stroke: (paint: gray, dash: "dashed"))

  // arrows connecting three nodes from left to right with straight mark
  line("obs", "step", mark: (end: "straight", fill: black))
  content((1.5, 1.3), padding: 3pt)[infer]

  // neural net symbol above infer
  content((1.5, 2.0), padding: 3pt)[
    #sym(symbols.symbol_neural_net)
  ]

  line("step", "act", mark: (end: "straight", fill: black))
  content((4.5, 1.3), padding: 3pt)[msg]
})
