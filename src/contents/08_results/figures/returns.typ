#import "/src/deps.typ": lilaq as lq, suiji

#let rng = suiji.gen-rng-f(39)
#let x = range(1, calc.pow(10, 5), step: calc.pow(10, 3))
#let y = x

#for i in range(y.len()) {
  let (rn, r) = suiji.random-f(rng)
  rng = rn
  y.at(i) = calc.log(y.at(i)) + r
}

#show: lq.layout

#show: lq.set-diagram(
  width: 3cm,
  height: 2cm,
  yaxis: (label: [Ep. Return]),
  xaxis: (ticks: none),
  legend: none,
)

#show grid.cell: it => {
  if it.x != 0 {
    return {
      show: lq.set-diagram(yaxis: (label: none, format-ticks: none))
      it
    }
  }
  return it
}

#show grid.cell.where(x: 3): it => {
  show: lq.set-diagram(legend: (position: left + top, dx: 100%))
  it
}

#let diag = lq.diagram(
  title: "train-mujoco",
  xaxis: (
    label: "Step %",
  ),
  yaxis: (:),
  lq.plot(
    x,
    y,
    mark: none,
    label: [15%],
  ),
  lq.plot(
    x,
    y.map(i => i / 2),
    mark: none,
    label: [30%],
  ),
)

#grid(
  columns: 4,
  column-gutter: 8pt,
  row-gutter: 8pt,
  diag, diag, diag, diag,
)
