#import "/src/lib.typ": letter-generic, address-tribox

#let fbox(color, content) = rect(width: 100%, height: 100%, inset: 3pt, fill: color)[
  #align(center + horizon)[
    #rect(fill: white, text(size: 8pt, content))
  ]
]

#set par(justify: true)
#set text(font: "Source Sans Pro", hyphenate: false)

#show: letter-generic.with(
  header: fbox(yellow, "header"),
  footer: fbox(yellow, "footer"),

  address-box: address-tribox(
    fbox(gray, "sender"),
    fbox(gray.darken(20%), "annotations"),
    fbox(gray.darken(40%), "recipient")
  ),
  
  information-box: fbox(navy, "information-box"),

  reference-signs: (
    (fbox(purple, "reference-signs[0]"), []),
    (fbox(purple, "reference-signs[1]"), []),
    (fbox(purple, "reference-signs[2]"), []),
    (fbox(purple, "reference‑signs[3]"), []),
    (fbox(purple, "reference-signs[4]"), []),
  ),

  page-numbering: (x, y) => "Page " + text(fill: eastern)[current-page] + " of " + text(fill: fuchsia)[page-count],
  
  margin: (
    bottom: 3cm,
  )
)

#align(right)[Date]

*Subject*

#lorem(1000)
