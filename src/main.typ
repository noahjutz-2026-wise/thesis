#import "/src/template.typ"

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
}

#bibliography(
  "/vendor/literature/sources.yaml",
  style: "assets/din-1505-2-alphanumeric.csl",
)
