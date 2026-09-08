#show: align.with(center + horizon)
#align(center)[
  #stack(
    dir: ltr,
    spacing: 24pt,
    image("/src/assets/logos/sappz.svg", height: 36pt, alt: "Logo SappZ"),
    image("/src/assets/logos/oth.svg", height: 36pt, alt: "Logo OTH Regensburg"),
  )
]

#title()

Bachelorarbeit

An der \
Ostbayerischen Technischen Hochschule Regensburg \
Fakultät Informatik/Mathematik

Aufgabensteller: Prof. Dr. Martin Weiß \
Zweitprüfer: Prof. Dr. Brijnesh Jain \
Betreuer: Prof. Dr. Matthias Ehrnsperger, Sensorik-ApplikationsZentrum

Vorgelegt von: #context document.author.join(",") \
Matrikelnummer: 3343960 \
Datum: Regensburg, den #context document.date.display("[day].[month].[year]")

#align(bottom)[
  #let hash = sys.inputs.at("GIT_HASH", default: none)
  #let tag = sys.inputs.at("GIT_TAG", default: none)
  #if hash != none [
    #hash.slice(0, calc.min(10, hash.len()))
    #if tag != none [
      (#tag)
    ]
  ]
]
