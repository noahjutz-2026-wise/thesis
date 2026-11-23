#import "/src/template.typ": template_subfigure
#show: template_subfigure
#grid(
  columns: 3,
  column-gutter: 16pt,
  [
    #figure(caption: [@CAD])[
      #rect(height: 125pt, width: 125pt, stroke: (dash: "dashed"))
    ] <fig:maze_cad.cad>
  ],
  [
    #figure(caption: [@CoACD Split])[
      #image("/src/assets/images/maze_coacd_expl.png", height: 125pt)
    ] <fig:maze_cad.mjlab>
  ],
  [
    #figure(caption: [mjlab])[
      #image("/src/assets/images/maze_mjlab_viser.png", height: 125pt)
    ] <fig:maze_cad.mjlab>
  ],
)
