#import "@preview/tidy:0.1.0"

#set text(
  font: "Source Sans Pro",
  hyphenate: false,
)

#let project-version = "2.1.0"
#let project-authors = "Sematre and contributors"

#set document(
  title: "Documentation for typst-letter-pro (Version " + project-version + ")",
  author: project-authors,
)

#set page(
  numbering: "1",

  footer: locate(loc => {
    let current-page = counter(page).at(loc).at(0)

    if current-page > 1 {
      grid(
        columns: (auto, 1fr, auto),
        gutter: 0.65em,
  
        [_typst-letter-pro_],
        
        rect(
          radius: 2pt,
          inset: 2pt,
          fill: blue.lighten(70%),
          
          text(6pt)[
            #set align(center + horizon)
            Version #project-version
          ]
        ),
        
        numbering("1", current-page),
      )
    }
  })
)

#show raw.where(block: true): block.with(
  width: 100%,
  fill: gray.lighten(85%),
  inset: 3mm,
  radius: 1.5mm,
)

#show raw.where(block: false): emph

#page[
  #set align(center)

  #v(10%)
  #box(text(34pt)[*typst-letter-pro*])\

  #v(10%)
  #stack(
    dir: ltr,
    spacing: 0.65em,
    
    rect(
      radius: 5pt,
      fill: blue.lighten(70%),
      
      text(12pt)[Version #project-version]
    ),
    
    rect(
      radius: 5pt,
      fill: orange.lighten(70%),
      
      text(12pt)[MIT license]
    )
  )

  _by #(project-authors)_

  #v(5%)
  #text(blue)[https://github.com/Sematre/typst-letter-pro]

  #v(1fr)
  /*
  #show outline.entry.where(
    level: 1
  ): it => {
    v(0.65em * 1.5, weak: true)
    it
  }
  */

  #rect(
    width: 60%,
    radius: 10pt,
    inset: 15pt,
    fill: gray.lighten(90%),
    
    outline(depth: 2, indent: 0.65em * 2)
  )
]

#set par(justify: true)
#show heading.where(level: 1): set text(size: 22pt)

= Description
typst-letter-pro provides a convenient and professional way to generate business letters with a standardized layout. The template follows the guidelines specified in the DIN 5008 standard, ensuring that your letters adhere to the commonly accepted business communication practices.

The goal of typst-letter-pro is to simplify the process of creating business letters while maintaining a clean and professional appearance.

= Quickstart

```typ
#import "@preview/letter-pro:2.1.0": letter-simple

#set text(lang: "de")

#show: letter-simple.with(
  sender: (
    name: "Anja Ahlsen",
    address: "Deutschherrenufer 28, 60528 Frankfurt",
    extra: [
      Telefon: #link("tel:+4915228817386")[+49 152 28817386]\
      E-Mail: #link("mailto:aahlsen@example.com")[aahlsen\@example.com]\
    ],
  ),
  
  annotations: [Einschreiben - Rückschein],
  recipient: [
    Finanzamt Frankfurt\
    Einkommenssteuerstelle\
    Gutleutstraße 5\
    60329 Frankfurt
  ],
  
  reference-signs: (
    ([Steuernummer], [333/24692/5775]),
  ),
  
  date: "12. November 2014",
  subject: "Einspruch gegen den ESt-Bescheid",
)

Sehr geehrte Damen und Herren,

#lorem(100)

Mit freundlichen Grüßen\
Anja Ahlsen
```

= Simple vs. Generic
typst-letter-pro offers 2 ways to create a letter: `letter-generic` and `letter-simple`.
The `letter-simple` function is an abstraction of the `letter-generic` function, which makes it easier to write a letter, without much extra work. It tries to have sane defaults for most applications but still wants to offer some dedgree of customizability. Your first choice should be the `letter-simple` function. Use the `letter-generic` function if you want to have as much control over the layout as possible. Helper functions are a way to make use of both worlds.

== Generic layout
#figure(
  rect(inset: 0.5pt, image("/docs/assets/letter-generic-layout.svg", height: 85%)),
  caption: [Page layout of `letter-generic`. Every layout option is highlighted.],
) <figure-pagebox-generic>

== Simple layout
#figure(
  rect(inset: 0.5pt, image("/docs/assets/letter-simple-layout.svg", height: 85%)),
  caption: [Page layout of `letter-simple`. Every layout option is highlighted.],
) <figure-pagebox-simple>

= Postage Stamp
== Deutsche Post
Deutsche Post offers digital franking marks that can be placed inside the address box of your letters. typst-letter-pro gives you an option to leave a little extra space for a stamp between the sender box and the recipient box.

#figure(
  rect(image("/docs/assets/stamp.svg", width: 35%)),
  caption: [Deutsche Post "Internetmarke"],
)

Enable stamping in your code:

```typ
#show: letter-simple.with(
  // [...]
  stamp: true,
  // [...]
)
```

Then generate the PDF and place the stamp using #link("https://github.com/qpdf/qpdf", text(fill: blue, "qpdf")) #footnote[https://github.com/qpdf/qpdf]:

```sh
$ qpdf path/to/letter.pdf --overlay path/to/stamp.pdf -- path/to/output.pdf
```

Note: This *ONLY* works with stamps of the format "DIN A4 Normalpapier (Einlegeblatt)".

= Functions

#show heading.where(level: 2): it => {
  pagebreak(weak: true)

  rect(
    width: 100%,
    stroke: (bottom: 1pt),
    inset: (
      bottom: 7pt,
      rest: 0pt,
    ),
    
    text(size: 22pt, style: "italic", it.body)
  )
  
  parbreak()
  v(0.65em)
}

#show heading.where(level: 3): rect.with(
  width: 100%,
  stroke: 0.5pt,
  fill: gray.lighten(85%)
)

#let module = tidy.parse-module(read("/src/lib.typ"))
#tidy.show-module(
  module,
  first-heading-level: 1,
  
  show-outline: true,
  
  sort-functions: it => {
    (
      "letter-simple":  11,
      "letter-generic": 12,
      
      "header-simple":   21,
      "sender-box":      22,
      "annotations-box": 23,
      "recipient-box":   24,
      "address-duobox":  25,
      "address-tribox":  26,
      
    ).at(it.name, default: 99)
  }
)
