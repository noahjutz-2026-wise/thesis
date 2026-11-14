#import "/src/deps.typ": lilaq as lq

#let clustered-bar(
  ..data,
  barfn: lq.bar,
  total_width: 80%,
) = {
  let offset(i, n, width) = (i - (n - 1) / 2) * width
  data = data.pos()
  let n = data.len()

  let width = total_width / n

  data
    .enumerate()
    .map(((i, args)) => {
      barfn(..args, width: width, offset: offset(i, n, width / 100%))
    })
}



#lq.diagram(
  title: "Performance before and after transfer",
  width: 10cm,
  xaxis: (
    label: [Mean episode return],
  ),
  yaxis: (
    ticks: ("Random Policy", "Zero-Shot", "DR").enumerate(),
    subticks: none,
  ),
  legend: (
    position: top + left,
    dx: 100%,
  ),
  ..clustered-bar(
    barfn: lq.hbar,
    arguments(
      (.1, .1, .1),
      range(3),
      label: [Sim],
    ),
    arguments(
      (.01, .01, .01),
      range(3),
      label: [Zero-Shot],
    ),
    arguments(
      (.02, .02, .02),
      range(3),
      label: [Fine-Tune],
    ),
  ),
)
