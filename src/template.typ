#import "/src/deps.typ": booktyps, citesugar, glossy
#import "/src/glossary.typ": gl-refs, glossary

#let _template_subimg(body) = {
  show figure.caption: it => {
    if it.kind == "subimg" {
      let idx = counter(figure.where(kind: "subimg")).get()
      numbering("(a) ", idx.last())
      it.body
    } else {
      it
    }
  }
  show figure.where(kind: "subimg"): set figure(supplement: "Figure")
  body
}

#let template_subfigure(it) = context {
  counter(figure.where(kind: "subimg")).update(0)
  let fig_number = counter(figure.where(kind: image)).get()
  set figure(
    kind: "subimg",
    numbering: n => {
      numbering("1a", ..fig_number, n)
    },
    supplement: "Figure",
  )
  it
}

#let template_base(body) = {
  show table: booktyps.booktabs
  show cite: citesugar.citesugar
  show cite.where(form: "author"): set cite(style: "apa")
  show cite.where(form: "prose"): set cite(style: "apa")
  set document(
    title: [
      Sim2Real Transfer of Deep Reinforcement Learning Algorithms to solve a Labyrinth Game
    ],
    author: "Noah Jutz",
    date: datetime(year: 2026, month: 12, day: 23),
  )
  set text(
    lang: "en",
    font: "New Computer Modern",
  )
  show figure: set block(breakable: true)
  show: glossy.init-glossary.with(
    glossary,
    term-links: true,
  )
  show: gl-refs
  set math.equation(numbering: "(1)")

  show: _template_subimg
  body
}

#let template_preamble(body) = {
  set page(numbering: "i", footer: none)
  set heading(outlined: false, bookmarked: true)
  body
}

#let template_doc(body) = {
  counter(page).update(1)
  show par: set par(justify: true)
  set page(numbering: "1")
  set heading(numbering: "1.1")
  body
}

#let template_appendix(body) = {
  counter(heading).update(1)
  set heading(numbering: (_, ..b) => {
    ("A", ..b.pos().map(str)).join(".", default: "")
  })
  body
}
