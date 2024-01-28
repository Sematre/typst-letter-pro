#import "/src/lib.typ": letter_generic, address_tribox

#let fbox(color, content) = rect(width: 100%, height: 100%, inset: 3pt, fill: color)[
  #align(center + horizon)[
    #rect(fill: white, text(size: 8pt, content))
  ]
]

#set par(justify: true)
#set text(font: "Source Sans Pro", hyphenate: false)

#show: letter_generic.with(
  header: fbox(yellow, "header"),
  footer: fbox(yellow, "footer"),

  address_box: address_tribox(
    fbox(gray, "sender"),
    fbox(gray.darken(20%), "annotations"),
    fbox(gray.darken(40%), "recipient")
  ),
  
  information_box: fbox(navy, "information_box"),

  reference_signs: (
    (fbox(purple, "reference_signs[0]"), []),
    (fbox(purple, "reference_signs[1]"), []),
    (fbox(purple, "reference_signs[2]"), []),
    (fbox(purple, "reference_signs[3]"), []),
    (fbox(purple, "reference_signs[4]"), []),
  ),

  page_numbering: (x, y) => "Page " + text(fill: eastern)[current_page] + " of " + text(fill: fuchsia)[page_count],
  
  margin: (
    bottom: 3cm,
  )
)

#align(right)[Date]

*Subject*

#lorem(1000)
