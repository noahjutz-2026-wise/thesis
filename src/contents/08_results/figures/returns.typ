#import "/src/deps.typ": lilaq as lq, suiji

#let xtitles = ("armature", "frictionloss", "gain", "all")
#let ytitles = ("sim return", "sim accuracy")

#let rng = suiji.gen-rng-f(39)
#let x = lq.linspace(0, 1, num: 150)
#let y = x

#for i in range(y.len()) {
  let (rn, r) = suiji.random-f(rng)
  rng = rn
  y.at(i) = calc.pow(y.at(i), 1 / 2) + r / 10
}

#show: lq.layout

#show: lq.set-diagram(
  width: 3cm,
  height: 2cm,
  xaxis: (format-ticks: none),
  yaxis: (format-ticks: none),
  legend: none,
)

#show grid.cell: it => {
  if it.x == 0 {
    return {
      show: lq.set-diagram(
        yaxis: (label: ytitles.at(it.y), format-ticks: auto),
      )
      it
    }
  }
  return it
}

#show grid.cell: it => {
  if it.y == 0 {
    return {
      show: lq.set-diagram(title: xtitles.at(it.x))
      it
    }
  }
  if it.y == ytitles.len() - 1 {
    return {
      show: lq.set-diagram(xaxis: (
        label: [Step %],
        format-ticks: auto,
        filter: (ticks, pos) => 0 < ticks and ticks < 1,
      ))
      it
    }
  }
  it
}

#show grid.cell.where(x: 2): it => {
  show: lq.set-diagram(legend: (position: left + top, dx: 100%))
  it
}

#let diag = lq.diagram(
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
  columns: 3,
  column-gutter: 8pt,
  row-gutter: 8pt,
  diag, diag, diag,
  diag, diag, diag,
)
