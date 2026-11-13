#import "/src/deps.typ": lilaq as lq

#lq.diagram(
  width: 100%,
  xaxis: (
    label: [max episode return],
  ),
  yaxis: (
    ticks: ("x", "y", "z").enumerate(),
    subticks: none,
  ),
  lq.hviolin(
    y: range(3),
    (1, 2),
    (2, 3, 10),
    (-1, 1, 3, 4, 5),
  ),
)
