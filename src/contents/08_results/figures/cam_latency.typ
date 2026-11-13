#import "/src/deps.typ": komet, lilaq as lq, suiji


#let data = csv("/vendor/data/cam_latency.csv").slice(1).flatten().map(float)

#let (counts, edges) = komet.histogram(data, bins: 50)
#let interval = edges.at(1) - edges.at(0)

#lq.diagram(
  width: 100%,
  xaxis: (
    // ticks: edges.chunks(10).map(array.first),
    ticks: auto,
  ),
  lq.bar(
    offset: interval / 2,
    width: 100%,
    stroke: .4pt + black.lighten(20%),
    fill: black.transparentize(80%),
    edges.slice(0, -1),
    counts,
  ),
)
