#import "/src/deps.typ": diagraph

#let cr_nodes = diagraph.render(
  engine: "dot",
  labels: (
    "interfaces",
    "dreamer",
    "dynamixel",
    "state_estimation",
    "camera",
  )
    .map(it => {
      (it, rect(it))
    })
    .to-dict(),
  "
    digraph {
      fontname=\"JetBrainsMono NF\"
      node[shape=none,margin=0,height=0,width=0]
      camera
      edge[style=dashed,color=gray]
      interfaces -> dreamer
      interfaces -> dynamixel
      interfaces -> state_estimation
      edge[style=solid,color=green]
      camera -> state_estimation -> dreamer -> dynamixel
    }
    ",
)

#grid(
  columns: 3,
  cr_nodes,
)
