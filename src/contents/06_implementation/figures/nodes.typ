#import "/src/deps.typ": fletcher, lilaq as lq
#import "/src/template.typ": template_subfigure
#import fletcher: diagram, edge, node

#let col_green = green
#let col_gray = gray

#let leg = {
  let arr(marks, stroke) = diagram(
    spacing: 1cm,
    edge((0, 0), (1, 0), marks, stroke: stroke),
  )

  let legend = lq.legend(
    arr("->", 1pt + col_green),
    [Publishes],
    arr("-->", 1pt + col_gray),
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

#let cr_nodes = diagram(
  spacing: (0cm, 1cm),
  node-stroke: 1pt,
  edge-stroke: 1pt + col_green,
  node((0, 0), `camera`, name: <camera>),
  edge("->"),
  node((0, 1), `state_estimation`, name: <state_estimation>),
  edge("->"),
  node((1, 2), `dreamer`, name: <dreamer>),
  edge("->"),
  node((2, 1), `dynamixel`, name: <dynamixel>),
  node((1, 3), `dreamerv3`, name: <dreamerv3>, stroke: col_gray),
  edge(<dreamerv3>, <dreamer>, "-->", stroke: col_gray),
)

#let crs2r_modules = diagram(
  spacing: (0cm, 1cm),
  node-stroke: 1pt,
  edge-stroke: 1pt + col_green,
  node((0, 0), `camera`, name: <camera>),
  edge("->"),
  node((0, 1), `vision`, name: <vision>),
  edge("->"),
  node((1, 2), `gym_real`, name: <gym_real>, stroke: col_gray),
  edge(<gym_real>, <actuator>, "->", stroke: col_green),
  node((2, 1), `actuator`, name: <actuator>),
  node((1, 1), `mpu`, name: <mpu>),
  edge(<mpu>, <gym_real>, "->", stroke: col_green),
  node((1, 3), `pipeline_rllib`, name: <pipeline_rllib>, stroke: col_gray),
  edge(<pipeline_rllib>, <gym_real>, "-->", stroke: col_gray),
)

#figure(caption: [@CR nodes (left) and reimplementation (right).])[
  #show: template_subfigure
  #set align(bottom)
  #block(width: 100%)[
    #grid(
      columns: 2,
      column-gutter: 16pt,
      row-gutter: 8pt,
      grid.cell(colspan: 2)[
        #leg

      ],
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
