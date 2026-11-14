#import "/src/deps.typ": cetz, diagraph, fletcher, lilaq as lq, oxifmt
#import "/src/template.typ": template_subfigure

#let col_green = green
#let col_gray = gray

#let shape_node = rect
#let shape_module = rect.with(stroke: col_gray)

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
    [Depends on],
    rect(width: 1cm, height: 6pt),
    [Node],
    rect(width: 1cm, height: 6pt, stroke: col_gray),
    [Module],
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
  labels: it => (
    () => {
      if it == "dreamerv3" { return shape_module }
      return shape_node
    }
  )()(it),
  edges: (
    "dreamer": (
      "dreamerv3": [#footnote[https://github.com/thomasbi1/cyberrunner/blob/40cf614cb84a46bd8cf2da37ecc048166a4bd848/cyberrunner_dreamer/cyberrunner_dreamer/eval.py#L4]],
    ),
  ),
  oxifmt.strfmt(
    "
    digraph {{
      fontname=\"JetBrainsMono NF\"
      node[shape=none,margin=0,height=0,width=0]
      camera
      edge[style=dashed,color=\"{gray}\"]
      // interfaces -> dreamer [dir=back]
      // interfaces -> dynamixel [dir=back]
      // interfaces -> state_estimation [dir=back]
      dreamer -> dreamerv3
      dreamer -> dreamerv3 [dir=back]
      edge[style=solid,color=\"{green}\"]
      camera -> state_estimation -> dreamer
      dynamixel -> dreamer [dir=back]
    }}
    ",
    gray: col_gray.to-hex(),
    green: col_green.to-hex(),
  ),
)

#let crs2r_modules = diagraph.render(
  engine: "dot",
  labels: it => (
    () => {
      if it == "rllib" { return shape_module }
      return shape_node
    }
  )()(it),
  oxifmt.strfmt(
    "
    digraph {{
      node[shape=none,margin=0,height=0,width=0]
      edge[style=solid,color=\"{green}\"]
      camera -> vision
      vision -> gymnasium
      mpu -> gymnasium
      actuator -> gymnasium [dir=back]
      edge[style=dashed,color=\"{gray}\"]
      gymnasium -> rllib [dir=back]
    }}
    ",
    gray: col_gray.to-hex(),
    green: col_green.to-hex(),
  ),
)

#figure(caption: [@CR nodes (left) and reimplementation (right).])[
  #show: template_subfigure
  #set align(bottom)
  #block(width: 100%)[
    #place(top + right)[
      #leg
    ]
    #grid(
      columns: 2,
      column-gutter: 16pt,
      [
        #figure(caption: [@CR @ROS Nodes])[
          #cr_nodes
        ] <fig:nodes.cr>
      ],
      [
        #figure(caption: [Reimplementation nodes])[
          #crs2r_modules
        ] <fig:nodes.reimpl>
      ],
    )
  ]
] <fig:nodes>
