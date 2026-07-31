#import "/template.typ"

#show: template.template_base
#{
  show: template.template_preamble

  include "contents/00_preamble/title_page.typ"
  pagebreak()

  include "contents/00_preamble/abstract.typ"
  pagebreak()

  outline()
  pagebreak()
}


#show: template.template_doc

#include "contents/01_introduction/intro.typ"

#pagebreak()

#bibliography(
  "bibliography.yml",
  style: "assets/din-1505-2-alphanumeric.csl",
)
