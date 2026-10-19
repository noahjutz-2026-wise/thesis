#import "/src/deps.typ": cetz

#let symbol_unity = {
  import cetz.draw: *
  // Outer frame of the 3D cube / arrows
  line((0.5, 1.0), (0.933, 0.75), (0.933, 0.25), (0.5, 0.0), (0.067, 0.25), (0.067, 0.75), close: true)
  // Inner arrow / cube creases meeting at center
  line((0.5, 0.5), (0.5, 1.0))
  line((0.5, 0.5), (0.067, 0.25))
  line((0.5, 0.5), (0.933, 0.25))
  // Inner chevron cuts characteristic of the Unity cube
  line((0.5, 0.75), (0.35, 0.663))
  line((0.5, 0.75), (0.65, 0.663))
  line((0.283, 0.375), (0.283, 0.55))
  line((0.283, 0.375), (0.433, 0.288))
  line((0.717, 0.375), (0.717, 0.55))
  line((0.717, 0.375), (0.567, 0.288))
}

#let symbol_iso_square_rod = {
  import cetz.draw: *
  // Isometric cube
  // Top face (center is at (0.45, 0.40))
  line((0.45, 0.55), (0.75, 0.40), (0.45, 0.25), (0.15, 0.40), close: true)
  // Left face vertical & bottom edge
  line((0.15, 0.40), (0.15, 0.15), (0.45, 0.00), (0.45, 0.25))
  // Right face vertical & bottom edge
  line((0.75, 0.40), (0.75, 0.15), (0.45, 0.00))
  // Rod going up from right side/corner, bending into a hook toward center
  line(
    (0.75, 0.40),
    (0.75, 0.88),
    (0.68, 0.95),
    (0.52, 0.95),
    (0.45, 0.88),
    (0.45, 0.74),
  )
  // Camera: square body on top, trapezoid/flaring lens pointing down toward cube (wider aperture at bottom)
  // Body (square)
  line((0.41, 0.69), (0.49, 0.69), (0.49, 0.74), (0.41, 0.74), close: true, fill: black, stroke: none)
  // Lens (flaring out downward towards the target)
  line((0.42, 0.69), (0.48, 0.69), (0.52, 0.62), (0.38, 0.62), close: true, fill: black, stroke: none)
}

#let symbol_module = {
  import cetz.draw: *
  // UML component (module): square body with two smaller squares
  // protruding from its left edge, equally spaced vertically
  // (margin below, between, and above the tabs are all equal)
  // Main body square
  line((0.3, 0.0), (1.0, 0.0), (1.0, 1.0), (0.3, 1.0), close: true)
  // Left tabs: heights 0.2, margins/gap 0.2 (0.2..0.4 and 0.6..0.8)
  line((0.05, 0.2), (0.3, 0.2), (0.3, 0.4), (0.05, 0.4), close: true)
  line((0.05, 0.6), (0.3, 0.6), (0.3, 0.8), (0.05, 0.8), close: true)
}

#let symbol_neural_net = {
  import cetz.draw: *
  // Connections between Layer 1 (2 nodes) and Layer 2 (3 nodes)
  line((0.15, 0.25), (0.5, 0.15))
  line((0.15, 0.25), (0.5, 0.5))
  line((0.15, 0.25), (0.5, 0.85))
  line((0.15, 0.75), (0.5, 0.15))
  line((0.15, 0.75), (0.5, 0.5))
  line((0.15, 0.75), (0.5, 0.85))

  // Connections between Layer 2 (3 nodes) and Layer 3 (2 nodes)
  line((0.5, 0.15), (0.85, 0.25))
  line((0.5, 0.15), (0.85, 0.75))
  line((0.5, 0.5), (0.85, 0.25))
  line((0.5, 0.5), (0.85, 0.75))
  line((0.5, 0.85), (0.85, 0.25))
  line((0.5, 0.85), (0.85, 0.75))

  // Layer 1 nodes (2 nodes)
  circle((0.15, 0.25), radius: 0.045, fill: black, stroke: none)
  circle((0.15, 0.75), radius: 0.045, fill: black, stroke: none)

  // Layer 2 nodes (3 nodes)
  circle((0.5, 0.15), radius: 0.045, fill: black, stroke: none)
  circle((0.5, 0.5), radius: 0.045, fill: black, stroke: none)
  circle((0.5, 0.85), radius: 0.045, fill: black, stroke: none)

  // Layer 3 nodes (2 nodes)
  circle((0.85, 0.25), radius: 0.045, fill: black, stroke: none)
  circle((0.85, 0.75), radius: 0.045, fill: black, stroke: none)
}

#let symbol_buffer = {
  import cetz.draw: *
  // 3 simple squares stacked with equal x and y offset (dx = dy = 0.16), no stroke overlap (no fill)
  // Back square: visible top and left edges
  line((0.68, 0.84), (0.68, 1.00), (0.00, 1.00), (0.00, 0.32), (0.16, 0.32))
  // Middle square: visible top and left edges
  line((0.84, 0.68), (0.84, 0.84), (0.16, 0.84), (0.16, 0.16), (0.32, 0.16))
  // Front square: full square
  line((0.32, 0.00), (1.00, 0.00), (1.00, 0.68), (0.32, 0.68), close: true)
}

#let symbol_metrics = {
  import cetz.draw: *
  // Coordinate axes
  line((0.1, 0.9), (0.1, 0.1), (0.9, 0.1))
  // Logarithmic / learning curve
  line(
    (0.1, 0.1),
    (0.18, 0.38),
    (0.28, 0.56),
    (0.40, 0.69),
    (0.55, 0.77),
    (0.72, 0.82),
    (0.9, 0.85),
  )
}

#let symbol_config = {
  import cetz.draw: *
  // Document outline
  line((0.15, 0.05), (0.85, 0.05), (0.85, 0.7), (0.6, 0.95), (0.15, 0.95), close: true)
  // Folded corner
  line((0.6, 0.95), (0.6, 0.7), (0.85, 0.7))
  // Hierarchical config / YAML key-value lines
  // Key 1
  line((0.25, 0.75), (0.4, 0.75))
  // Key 2
  line((0.25, 0.55), (0.42, 0.55))
  // Indented item 2.1
  line((0.35, 0.40), (0.48, 0.40))
  line((0.55, 0.40), (0.75, 0.40))
  // Indented item 2.2
  line((0.35, 0.25), (0.48, 0.25))
  line((0.55, 0.25), (0.7, 0.25))
}
