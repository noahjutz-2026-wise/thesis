#import "/src/deps.typ": cetz
#import "/src/template.typ": template_subfigure

#let d-camera = (-0.08904523, 0.17295061, -0.31256602, 0.24255281)

// Every grid is normalized to the same box, so distortion shows as a
// change of the interior line spacing, not the overall size.
#let dgrid(d, fisheye: false) = cetz.canvas(length: 0.25cm, {
  import cetz.draw: *

  // Rectilinear: normalized image coords, r <= 1, keeps the k_i small.
  // Fisheye: maps the grid onto realistic camera ray angles (max ~1.3 rad).
  let scale-norm = if fisheye { 2.0 } else { 7.0711 }
  let ext = 5.0
  let steps = 20

  let distort-raw((x, y)) = {
    let nx = x / scale-norm
    let ny = y / scale-norm
    let r = calc.sqrt(nx * nx + ny * ny)
    if r < 1e-6 { return (x, y) }
    let theta = if fisheye { calc.atan(r) / 1rad } else { r }
    let t2 = theta * theta
    let theta-d = theta * (1 + t2 * (d.at(0) + t2 * (d.at(1) + t2 * (d.at(2) + t2 * d.at(3)))))
    let s = theta-d / r * scale-norm
    (nx * s, ny * s)
  }

  // Normalize so every grid fills the same box: scale by the largest
  // coordinate component over the boundary of the undistorted square.
  let n = 50
  let maxc = range(n + 1).fold(0.0, (acc, i) => {
    let t = -ext + 2 * ext * i / n
    ((ext, t), (-ext, t), (t, ext), (t, -ext)).fold(acc, (a, p) => {
      let (px, py) = distort-raw(p)
      calc.max(a, calc.max(calc.abs(px), calc.abs(py)))
    })
  })
  let k = ext / maxc
  let distort((x, y)) = {
    let (px, py) = distort-raw((x, y))
    (px * k, py * k)
  }

  set-style(stroke: 0.7pt + blue)

  // Draw vertical and horizontal grid lines
  for i in range(-5, 6) {
    let v-pts = range(steps + 1).map(s => {
      let t = -ext + 2 * ext * s / steps
      distort((float(i), t))
    })
    line(..v-pts)
    let h-pts = range(steps + 1).map(s => {
      let t = -ext + 2 * ext * s / steps
      distort((t, float(i)))
    })
    line(..h-pts)
  }
})

#figure(
  caption: [
    Radial distortion of a regular grid. (a) Undistorted rectilinear grid,
    (b) barrel distortion, (c) pincushion distortion and (d) the distortion
    model of our fisheye camera, calibrated with the fisheye module of @OpenCV.
  ],
)[
  #show: template_subfigure
  #grid(
    columns: 4,
    column-gutter: 16pt,
    row-gutter: 10pt,
    [#figure(caption: [Normal])[#dgrid((0.0, 0.0, 0.0, 0.0))] <fig:lensdistort.normal>],
    [#figure(caption: [Barrel])[#dgrid((-0.15, 0.0, 0.0, 0.0))] <fig:lensdistort.barrel>],

    [#figure(caption: [Pincushion])[#dgrid((0.15, 0.0, 0.0, 0.0))] <fig:lensdistort.pincushion>],
    [#figure(caption: [Fisheye camera])[#dgrid(d-camera, fisheye: true)] <fig:lensdistort.camera>],
  )
] <fig:lensdistort>
