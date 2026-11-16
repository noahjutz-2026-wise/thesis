#import "/src/deps.typ": cetz
#import "/src/common/symbols.typ": symbol_camera

// Homography-based ball localization: the ball's pixel defines a viewing
// ray through the optical center; its intersection with the tilted board
// plane (known from PnP) is the ball's position on the board.
#let homography = cetz.canvas(length: 0.75cm, {
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

  // Tilted board, seen edge-on, with known pose from PnP
  line((8, 0), (12, 4))
  content((10, 4.2), [$bold(H)$])

  // Ball on the board
  circle((10, 2), radius: 0.06, fill: black)
  content((10, 2), [$bold(b)$], anchor: "north")

  // Viewing ray from the camera through the ball's pixel to the ball
  line((0, 0), (10, 2), name: "ray")
  circle((name: "ray", anchor: 40%), radius: 0.06, fill: black)
  content((name: "ray", anchor: 40%), [$bold(u)$], anchor: "west")
})

#figure(
  caption: [
    Ball localization on a tilted plane. The board's pose from PnP defines
    the homography $bold(H)$ between the board plane and the image. The
    detected ball pixel $bold(u)$ fixes a viewing ray through the optical
    center; its intersection with the tilted board plane is the ball's
    position $bold(b)$ on the board.
  ],
)[
  #homography
] <fig:homography>
