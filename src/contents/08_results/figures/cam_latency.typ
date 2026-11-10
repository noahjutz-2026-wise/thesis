#import "/src/deps.typ": komet, lilaq as lq, suiji

#let rng = suiji.gen-rng-f(40)
#let (rng, data) = suiji.uniform-f(rng, size: 10000)

#let (counts, edges) = komet.histogram(data, bins: 15)
#let interval = edges.at(1) - edges.at(0)

#lq.diagram(
  width: 100%,
  xaxis: (
    ticks: edges.chunks(3).map(array.first),
  ),
  lq.bar(
    offset: interval / 2,
    width: 100%,
    stroke: 1pt + black,
    fill: gray,
    edges.slice(0, -1),
    counts,
  ),
)
