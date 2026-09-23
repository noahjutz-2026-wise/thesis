#set align(center)

#stack(
  dir: ltr,
  spacing: 24pt,
  image("/src/assets/logos/sappz.svg", height: 36pt, alt: "Logo SappZ"),
  image("/src/assets/logos/oth.svg", height: 36pt, alt: "Logo OTH Regensburg"),
)

#set align(horizon)

#title()

Bachelor's Thesis

At the \
Ostbayerische Technische Hochschule Regensburg \
Faculty of Computer Science and Mathematics \

Examiner: Prof. Dr. Martin Weiß \
Second Examiner: Prof. Dr. Brijnesh Jain \
Advisor: Prof. Dr. Matthias Ehrnsperger, Sensorik-ApplikationsZentrum

Submitted by: #context document.author.join(",") \
Student ID: 3343960 \

Regensburg, #context document.date.display()

#set align(bottom)

#let hash = sys.inputs.at("GIT_HASH", default: "").trim()
#let tag = sys.inputs.at("GIT_TAG", default: "").trim()
#if hash.len() > 0 [
  Version #hash.slice(0, calc.min(10, hash.len()))
  #if tag.len() > 0 [
    (#tag)
  ]
]
