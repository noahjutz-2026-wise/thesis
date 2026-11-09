#import "/src/deps.typ": cetz, diagraph, fletcher, lilaq as lq, oxifmt

#let col_green = green
#let col_gray = gray

#let leg = {
  let arr(length: .6cm, ..args) = cetz.canvas(length: length, {
    import cetz.draw: *
    let kwargs = args.named()
    line((0, 0), (1, 0), ..kwargs)
  })

  let arr(length: 1cm, ..args) = fletcher.diagram(spacing: (length, length), {
    import fletcher: edge
    let kwargs = args.named()
    let posargs = args.pos()
    edge(..posargs, ..kwargs)
  })

  let legend = lq.legend(
    arr("-|>", stroke: (paint: col_green, thickness: 1pt)),
    [Publishes],
    arr("-|>", stroke: (paint: col_gray, dash: "dashed", thickness: 1pt)),
    [Reference trajectory],
  )

  show lq.selector(lq.legend): set grid(
    columns: (auto, auto),
    column-gutter: 10pt,
    row-gutter: 6pt,
    align: (center + horizon, left + horizon),
  )

  legend
}

#let cr_nodes = diagraph.render(
  engine: "dot",
  labels: rect,
  oxifmt.strfmt(
    "
    digraph {{
      fontname=\"JetBrainsMono NF\"
      node[shape=none,margin=0,height=0,width=0]
      camera
      edge[style=dashed,color=\"{gray}\"]
      interfaces -> dreamer
      interfaces -> dynamixel
      interfaces -> state_estimation
      edge[style=solid,color=\"{green}\"]
      camera -> state_estimation -> dreamer -> dynamixel
    }}
    ",
    gray: col_gray.to-hex(),
    green: col_green.to-hex(),
  ),
)

#grid(
  columns: 3,
  cr_nodes, leg,
)
