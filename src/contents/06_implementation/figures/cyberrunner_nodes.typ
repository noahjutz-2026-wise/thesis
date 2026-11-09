#import "/src/deps.typ": diagraph
#diagraph.render(
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
      // fontname=\"JetBrainsMono NF\"
      node[shape=none,margin=0,height=0,width=0]
      camera
      edge[label=dependency,style=dashed,color=gray]
      interfaces -> dreamer
      interfaces -> dynamixel
      interfaces -> state_estimation
      edge[label=publishes,style=solid,color=green]
      camera -> state_estimation -> dreamer -> dynamixel
    }
    ",
)
