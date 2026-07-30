#import "/template.typ"

#show: template.template

#set document(
  title: [
    Sim-to-Real-Transfer von Reinforcement-Learning-Modellen aus einem digitalen Zwilling auf einen physischen Kugellabyrinth-Roboter
  ],
  author: "Noah Jutz",
  date: datetime(year: 2026, month: 12, day: 23),
)

#title()

#outline()

#pagebreak()

Hello World @bib_cyberrunner!

#pagebreak()

#bibliography(
  "bibliography.yml",
  style: "assets/din-1505-2-alphanumeric.csl",
)
