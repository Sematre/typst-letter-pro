// typst-letter
// 
// Project page:
// https://github.com/Sematre/typst-letter
// 
// References:
// https://de.wikipedia.org/wiki/DIN_5008
// https://www.deutschepost.de/de/b/briefvorlagen/normbrief-din-5008-vorlage.html
// https://www.deutschepost.de/content/dam/dpag/images/P_p/printmailing/downloads/automationsfaehige-briefsendungen-2023.pdf
// https://www.edv-lehrgang.de/din-5008/
// https://www.edv-lehrgang.de/anschriftfeld-im-din-5008-geschaeftsbrief/

#let letter_generic(
  header: [],
  footer: [],
  
  address_box: [],
  information_box: [],
  
  reference_signs: (),
  
  date: none,
  subject: none,
  
  content,
  margin: (
    left: 25mm,
    right: 20mm,
    top: 2cm,
    bottom: 2cm
  )
) = {
  set page(
    paper: "a4",
    margin: (
      left: margin.left,
      right: margin.right,
      top: margin.top,
      bottom: margin.bottom,
    ),
    
    background: locate(loc => {
      // folding mark 1
      place(top + left, dy: 105mm, line(
          length: 2.5mm,
          stroke: 0.25pt + black
      ))
      
      // folding mark 2
      place(top + left, dy: 105mm + 105mm, line(
          length: 2.5mm,
          stroke: 0.25pt + black
      ))
      
      // hole mark
      place(left + top, dy: 148.5mm, line(
        length: 4mm,
        stroke: 0.25pt + black
      ))
    }),
    
    footer: locate(loc => {
      let current_page = loc.page()
      let page_count = counter(page).final(loc).at(0)
      
      if page_count > 1 {
        align(right, text(10pt)[
          Seite #current_page von #page_count
        ])
      }
      
      if current_page == 1 {
        v(4.23mm, weak: true)
        align(left + bottom, footer)
        v(4.23mm)
      }
    })
  )
  
  set text(font: "Liberation Sans", size: 12pt)
  
  // Reverse margin
  place(dy: -margin.top, dx: -margin.left,  {
    // Briefkopf
    place(top + left, block(
      width: 210mm,
      height: 45mm,
      header
    ))
    
    // Anschriftfeld
    place(top + left, dx: 20mm, dy: 45mm, block(
      width: 85mm,
      height: 45mm,
      address_box
    ))
    
    // Informationsblock
    place(top + left, dx: 125mm, dy: 50mm, block(
      width: 75mm,
      height: 40mm,
      information_box
    ))
  })
  
  // Spacer: 98.46mm
  v((45mm + 45mm + 8.46mm) - margin.top)
  
  // Bezugszeichen
  if reference_signs.len() > 0 {
    grid(
      // Total width: 175mm
      // Delimiter: 4.23mm
      // Cell width: 50mm - 4.23mm = 45.77mm
      columns: (45.77mm, 45.77mm, 45.77mm, 25mm),
      rows: 4.23mm * 2,
      gutter: 4.23mm,
      ..reference_signs.map(sign => {
        text(size: 8pt, sign.at(0))
        linebreak()
        text(size: 10pt, sign.at(1))
      })
    )
    
    v(4.23mm)
  }
  
  // Date
  if date != none {
    align(right, date)
    v(4.23mm)
  }
  
  // Subject
  if subject != none {
    strong(subject)
    v(4.23mm)
  }
  
  // Content
  content
}

#let tribox(sender: [], annotations: [], recipient: []) = {
  grid(
    columns: 1,
    rows: (5mm, 12.7mm, 27.3mm),
    sender,
    annotations,
    recipient
  )
}

#let duobox(sender: [], recipient: []) = {
  grid(
    columns: 1,
    rows: (17.7mm, 27.3mm),
    sender,
    recipient
  )
}

#let letter_simple(
  sender: (
    name: [],
    address: [],
    extra: [],
  ),
  
  annotations: [],
  recipient: [],
  
  reference_signs: (),
  
  date: none,
  subject: none,
  
  content,
  margin: (
    left: 25mm,
    right: 20mm,
    top: 2cm,
    bottom: 2cm
  )
) = {
  let header = {
    pad(
      left: margin.left,
      right: margin.right,
      top: margin.top,
      bottom: 5mm,
      
      align(top + right, [
        #set text(size: 10pt)
        
        *#sender.name*\
        #sender.address.split(", ").join(linebreak())\
        #sender.extra
      ])
    )
  }
  
  let sender_box = {
    set text(size: 7pt)
    set align(horizon)
    
    pad(left: 5mm, underline(offset: 2pt, {
      sender.name
      ", "
      sender.address
    }))
  }
  
  let annotations_box = {
    set text(size: 7pt)
    set align(bottom)
    
    pad(left: 5mm, bottom: 2mm, annotations)
  }
  
  let recipient_box = {
    set text(size: 10pt)
    set align(top)
    
    pad(left: 5mm, recipient)
  }
  
  // Set the document metadata
  set document(
    title: subject,
    author: sender.name
  )
  
  letter_generic(
    header: header,
    
    address_box: tribox(
      sender: sender_box,
      annotations: annotations_box,
      recipient: recipient_box
    ),
    
    date: date,
    subject: subject,
    reference_signs: reference_signs,
    
    content,
    margin: margin,
  )
}
