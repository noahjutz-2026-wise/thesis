#import "/src/deps.typ": glossarium
#import "/src/glossary.typ": glossary

#let template_base(body) = {
  set document(
    title: [
      Sim-to-Real-Transfer von Reinforcement-Learning-Modellen aus einem digitalen Zwilling auf einen physischen Kugellabyrinth-Roboter
    ],
    author: "Noah Jutz",
    date: datetime(year: 2026, month: 12, day: 23),
  )
  set text(lang: "de")
  show: glossarium.make-glossary
  glossarium.register-glossary(glossary)
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
