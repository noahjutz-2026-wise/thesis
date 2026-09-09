#import "/src/deps.typ": glossy
#import "/src/glossary.typ": glossary

#let template_base(body) = {
  set document(
    title: [
      CR-S2R: Sim-to-Real Transfer am Beispiel des CyberRunners mit ML-Agents
    ],
    author: "Noah Jutz",
    date: datetime(year: 2026, month: 12, day: 23),
  )
  set text(
    lang: "de",
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
  set page(numbering: "1")
  set heading(numbering: "1.1")
  body
}
