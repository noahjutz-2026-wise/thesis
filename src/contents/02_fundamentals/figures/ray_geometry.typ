#import "/src/deps.typ": cetz
#import "/src/common/symbols.typ": symbol_camera

#cetz.canvas(length: 0.75cm, {
  import cetz.draw: *
  import cetz.angle: angle, right-angle

  set-style(stroke: 1pt, content: (padding: 4pt))

  circle((4, 3), radius: 2pt, fill: black, stroke: none, name: "v")
  content((), anchor: "south-west")[$bold(v)$]

  line((0, 0), (4, 0), stroke: (dash: "dashed", paint: gray))
  content((2, 0), [$Z=1$], anchor: "north")

  line((4, -3.5), (4, 3.5))

  group({
    translate((6pt, 0pt))
    line((4, 0), (4, 3), stroke: (paint: gray), name: "rline", mark: (start: "bar", end: "bar"))
    content("rline.mid", anchor: "west")[$r$]
  })

  line((0, 0), (4, 3))

  angle((0, 0), (4, 0), "v", label: $theta$, label-radius: 200%)
  right-angle((4, 0), (0, 0), (4, 3))

  group({
    translate((-1, -0.5))
    symbol_camera
  })
})
