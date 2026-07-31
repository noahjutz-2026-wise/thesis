#let template_base(body) = {
  set document(
    title: [
      Sim-to-Real-Transfer von Reinforcement-Learning-Modellen aus einem digitalen Zwilling auf einen physischen Kugellabyrinth-Roboter
    ],
    author: "Noah Jutz",
    date: datetime(year: 2026, month: 12, day: 23),
  )
  set text(lang: "de")
  body
}

#let template_preamble(body) = {
  show: template_base
  set heading(outlined: false, bookmarked: true)
  body
}

#let template_doc(body) = {
  show: template_base
  counter(page).update(1)
  set page(numbering: "1")
  set heading(numbering: "1.1")
  body
}
