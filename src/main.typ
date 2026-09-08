#import "/src/template.typ"
#import "/src/deps.typ": glossy
#import "/src/glossary.typ": glossary

#show: template.template_base
#{
  show: template.template_preamble

  include "/src/contents/00_preamble/title_page.typ"
  pagebreak()

  include "/src/contents/00_preamble/abstract.typ"
  pagebreak()

  outline()
  pagebreak()
}


#show: template.template_doc

#{
  include "/src/contents/01_introduction/main.typ"
  pagebreak()

  include "/src/contents/02_related_works/main.typ"
  pagebreak()

  include "/src/contents/03_fundamentals/main.typ"
  pagebreak()

  include "/src/contents/04_methodology/main.typ"
  pagebreak()

  include "contents/05_requirements/main.typ"
  pagebreak()

  include "contents/06_implementation/main.typ"
  pagebreak()
}

#{
  set heading(numbering: none)
  show heading.where(level: 2): set heading(outlined: false)
  glossy.glossary(
    title: [Glossar],
    theme: glossy.theme-basic,
  )
}

#bibliography(
  "/vendor/literature/sources.yaml",
  style: "assets/din-1505-2-alphanumeric.csl",
)
