#import "/src/template.typ": template_subfigure
#show: template_subfigure
#show: align.with(horizon)

#let shape = box.with(height: 100pt)
#grid(
  columns: 3,
  column-gutter: 16pt,
  [
    #figure(caption: [@CAD])[
      #show: shape
      #image("/src/assets/images/maze_build123d.png", height: 70%)
    ] <fig:maze_cad.cad>
  ],
  [
    #figure(caption: [@CoACD Split])[
      #show: shape
      #image("/src/assets/images/maze_coacd_expl.png", height: 100%)
    ] <fig:maze_cad.mjlab>
  ],
  [
    #figure(caption: [mjlab])[
      #show: shape
      #image("/src/assets/images/maze_mjlab_viser.png", height: 100%)
    ] <fig:maze_cad.mjlab>
  ],
)
