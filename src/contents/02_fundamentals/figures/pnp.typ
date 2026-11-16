#import "/src/deps.typ": cetz
#import "/src/common/symbols.typ": symbol_camera

// Perspective-n-Point: known 3D points on the board are observed as
// pixels in the image; solving for the camera-to-board pose (R, t) that
// makes the projections match yields the board's tilt.
#let pnp = cetz.canvas(length: 0.75cm, {
  import cetz.draw: *

  set-style(stroke: 1pt, content: (padding: 4pt))

  // Camera at the optical center
  group({
    translate((-0.95, -0.5))
    symbol_camera
  })

  // Image plane
  line((4, -2), (4, 3))
  content((4, -2), [image], anchor: "north")

  // Board, seen edge-on as a tilted line
  line((8, 0), (12, 3))

  // Known 3D points on the board
  circle((8, 0), radius: 0.06, fill: black)
  circle((12, 3), radius: 0.06, fill: black)
  content((10, 1.5), [$bold(X)_i$], anchor: "south")

  // Detected pixels in the image plane (ray-plane intersections)
  circle((4, 0), radius: 0.06, fill: black)
  circle((4, 1), radius: 0.06, fill: black)
  content((4, 0), [$bold(u)_i$], anchor: "west")

  // Viewing rays from the camera through the pixels to the board points
  line((0, 0), (8, 0))
  line((0, 0), (12, 3))

  // Board pose recovered by PnP
  content((10, 3.2), [$bold(R), bold(t)$])
})

#figure(
  caption: [
    @PnP. Known 3D points $bold(X)_i$ on the board are
    detected as pixels $bold(u)_i$ in the image. Solving PnP finds the
    board pose $bold(R), bold(t)$ for which the camera model projects each
    $bold(X)_i$ exactly onto its detected $bold(u)_i$.
  ],
)[
  #pnp
] <fig:pnp>
