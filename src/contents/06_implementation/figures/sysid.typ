#import "/src/deps.typ": fletcher
#import "/src/common/util.typ": symbol
#import "/src/common/symbols.typ"

#let symbol = symbol.with(symbol-size: .6cm, canvas-size: .6cm)

#fletcher.diagram(
  node-shape: fletcher.shapes.rect,
  cell-size: 0cm,
  spacing: (.5cm, 0cm),
  {
    import fletcher: edge, node
    node((0, 0))[$(t,u)$]
    edge("->")
    node((1, 0), stroke: 1pt, width: 1cm, height: 1cm)[#symbol(symbols.symbol_iso_square_rod)]
    edge("->")
    node((2, 0))[$(t, y)$]

    node((0, 2))[$(t,u)$]
    edge("->")
    node((1, 2), stroke: 1pt, width: 1cm, height: 1cm)[$M(theta)$]
    edge("->")
    node((2, 2))[$(t, hat(y))$]

    edge((2, 0), (3, 1), "->")
    edge((2, 2), (3, 1), "->")
    node((3, 1))[$hat(y)_t - y_t = r(theta)$]
  },
)
