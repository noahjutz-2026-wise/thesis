#import "/src/deps.typ": lilaq as lq

#let data = json("/vendor/data/wandb_returns.json")

#let _ = data.remove("rew-holes-0.1")

#lq.diagram(
  width: 100%,
  height: 22cm,
  xaxis: (
    label: [max episode return],
  ),
  yaxis: (
    ticks: data.keys().enumerate(),
    subticks: none,
  ),
  lq.hviolin(
    y: range(data.len()),
    ..data.values(),
  ),
)
