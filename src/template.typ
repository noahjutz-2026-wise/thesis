#import "/src/deps.typ": glossy
#import "/src/deps.typ": citesugar
#import "/src/glossary.typ": glossary

#let template_base(body) = {
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
  show: glossy.init-glossary.with(
    glossary,
    term-links: true,
  )
  body
}

#let template_preamble(body) = {
  set page(numbering: "i", footer: none)
  set heading(outlined: false, bookmarked: true)
  body
}

#let template_doc(body) = {
  counter(page).update(1)
  set par(justify: true)
  set page(numbering: "1")
  set heading(numbering: "1.1")
  body
}
