// ################
// # typst-letter #
// ################
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

// ##################
// # Generic letter #
// ##################
// 
// This function gets your whole document as its `body`
// and formats it as a generic letter.
#let letter_generic(
  // The letter's format, which decides the position of the folding marks and the size of the header
  format: "DIN-5008-B",
  
  // The letter's header, which is displayed at the top of the page.
  header: none,
  
  // The letter's footer, which is displayed at the bottom of the page.
  footer: none,
  
  // The letter's folding marks, which are displayed at the left margin.
  folding_marks: true,
  
  // The letter's hole mark, which is displayed at the left margin.
  hole_mark: true,
  
  // The letter's address box, which is displayed below the header on the left.
  address_box: none,
  
  // The letter's information box, which is displayed below the header on the right.
  information_box: none,
  
  // The letter's reference signs, which are displayed below the the address box.
  reference_signs: none,
  
  page_numbering: (current_page, page_count) => {
    "Seite " + str(current_page) + " von " + str(page_count)
  },
  
  // The letter's content.
  body,
  
  // The letter's page margins
  margin: (
    left:   25mm,
    right:  20mm,
    top:    20mm,
    bottom: 20mm,
  )
) = {
  let letter_formats = (
    "DIN-5008-A": (
      folding_mark_1_pos: 87mm,
      folding_mark_2_pos: 87mm + 105mm,
      header_size: 27mm,
    ),
    
    "DIN-5008-B": (
      folding_mark_1_pos: 105mm,
      folding_mark_2_pos: 105mm + 105mm,
      header_size: 45mm,
    ),
  )
  
  if not letter_formats.keys().contains(format) {
    panic("Invalid letter format! Options: " + letter_formats.keys().join(", "))
  }
  
  margin = (
    left:   margin.at("left",   default: 25mm),
    right:  margin.at("right",  default: 20mm),
    top:    margin.at("top",    default: 20mm),
    bottom: margin.at("bottom", default: 20mm),
  )
  
  set page(
    paper: "a4",
    flipped: false,
    
    margin: margin,
    
    background: {
      if folding_marks {
        // folding mark 1
        place(top + left, dx: 5mm, dy: letter_formats.at(format).folding_mark_1_pos, line(
            length: 2.5mm,
            stroke: 0.25pt + black
        ))
        
        // folding mark 2
        place(top + left, dx: 5mm, dy: letter_formats.at(format).folding_mark_2_pos, line(
            length: 2.5mm,
            stroke: 0.25pt + black
        ))
      }
      
      if hole_mark {
        // hole mark
        place(left + top, dx: 5mm, dy: 148.5mm, line(
          length: 4mm,
          stroke: 0.25pt + black
        ))
      }
    },
    
    footer-descent: 0%,
    footer: locate(loc => {
      show: pad.with(top: 12pt, bottom: 12pt)
      
      let current_page = loc.page()
      let page_count = counter(page).final(loc).at(0)
      
      grid(
        columns: 1fr,
        rows: (0.65em, 1fr),
        row-gutter: 12pt,
        
        if page_count > 1 {
          align(right, page_numbering(current_page, page_count))
        },
        
        if current_page == 1 {
          footer
        }
      )
    }),
  )
  
  // Reverse the margin for the header, the address box and the information box
  pad(top: -margin.top, left: -margin.left, right: -margin.right, {
    grid(
      columns: 100%,
      rows: (letter_formats.at(format).header_size, 45mm),
      
      // Header box
      header,
      
      // Address / Information box
      pad(left: 20mm, right: 10mm, {
        grid(
          columns: (85mm, 75mm),
          rows: 45mm,
          column-gutter: 20mm,
          
          // Address box
          address_box,
          
          // Information box
          pad(top: 5mm, information_box)
        )
      }),
    )
  })

  v(12pt)

  // Reference signs
  if (reference_signs != none) and (reference_signs.len() > 0) {
    grid(
      // Total width: 175mm
      // Delimiter: 4.23mm
      // Cell width: 50mm - 4.23mm = 45.77mm
      
      columns: (45.77mm, 45.77mm, 45.77mm, 25mm),
      rows: 12pt * 2,
      gutter: 12pt,
      
      ..reference_signs.map(sign => {
        let (key, value) = sign
        
        text(size: 8pt, key)
        linebreak()
        text(size: 10pt, value)
      })
    )
  }
  
  // Add body.
  body
}

// ####################
// # Helper functions #
// ####################

#let header_simple(name, address, extra: none) = {
  set text(size: 10pt)

  strong(name)
  linebreak()
  
  address
  linebreak()

  if extra != none {
    extra
  }
}

#let sender_box(name: none, address) = {
  set text(size: 7pt)
  set align(horizon)
  
  pad(left: 5mm, underline(offset: 2pt, {
    if name != none {
      name
      ", "
    }
    
    address
  }))
}

#let annotations_box(content) = {
  set text(size: 7pt)
  set align(bottom)
  
  pad(left: 5mm, bottom: 2mm, content)
}

#let recipient_box(content) = {
  set text(size: 10pt)
  set align(top)
  
  pad(left: 5mm, content)
}

#let address_duobox(sender, recipient) = {
  grid(
    columns: 1,
    rows: (17.7mm, 27.3mm),
      
    sender,
    recipient,
  )
}

#let address_tribox(sender, annotations, recipient, stamp: false) = {
  if stamp {
    grid(
      columns: 1,
      rows: (5mm, 12.7mm + (4.23mm * 2), 27.3mm - (4.23mm * 2)),
      
      sender,
      annotations,
      recipient,
    )
  } else {
    grid(
      columns: 1,
      rows: (5mm, 12.7mm, 27.3mm),
      
      sender,
      annotations,
      recipient,
    )
  }
}

// #################
// # Simple letter #
// #################
// 
// This function gets your whole document as its `body`
// and formats it as a simple letter.
#let letter_simple(
  // The letter's format, which decides the position of the folding marks and the size of the header
  format: "DIN-5008-B",
  
  // The letter's header, which is displayed at the top of the page.
  header: none,

  // The letter's footer, which is displayed at the bottom of the page.
  footer: none,

  // The letter's folding marks, which are displayed at the left margin.
  folding_marks: true,

  // The letter's hole mark, which is displayed at the left margin.
  hole_mark: true,
  
  // The letter's sender, which is displayed below the header on the left.
  sender: (
    name: none,
    address: none,
    extra: none,
  ),
  
  // The letter's recipient, which is displayed below the annotations.
  recipient: none,

  // The letter's postage stamp, which is displayed below the sender.
  stamp: false,

  // The letter's annotations box, which is displayed below the stamp
  annotations: none,
  
  // The letter's information box, which is displayed below the header on the right.
  information_box: none,

  // The letter's reference signs, which are displayed below the the address box.
  reference_signs: none,
  
  // The date, displayed to the right.
  date: none,
  
  // The subject line.
  subject: none,

  page_numbering: (current_page, page_count) => {
    "Seite " + str(current_page) + " von " + str(page_count)
  },
  
  // The letter's content.
  body,

  // The letter's margin
  margin: (
    left:   25mm,
    right:  20mm,
    top:    20mm,
    bottom: 20mm,
  )
) = {
  margin = (
    left:   margin.at("left",   default: 25mm),
    right:  margin.at("right",  default: 20mm),
    top:    margin.at("top",    default: 20mm),
    bottom: margin.at("bottom", default: 20mm),
  )
  
  // Configure page and text properties.
  set document(
    title: subject,
    author: sender.name,
  )

  set text(font: "Source Sans Pro", hyphenate: false)

  // Create a simple header if there is none
  if header == none {
    header = pad(
      left: margin.left,
      right: margin.right,
      top: margin.top,
      bottom: 5mm,
      
      align(bottom + right, header_simple(
        sender.name,
        sender.address.split(", ").join(linebreak()),
        extra: sender.at("extra", default: none),
      ))
    )
  }

  let sender_box      = sender_box(name: sender.name, sender.address)
  let annotations_box = annotations_box(annotations)
  let recipient_box   = recipient_box(recipient)

  let address_box     = address_tribox(sender_box, annotations_box, recipient_box, stamp: stamp)
  
  letter_generic(
    format: format,
    
    header: header,
    footer: footer,

    folding_marks: folding_marks,
    hole_mark: hole_mark,
    
    address_box:     address_box,
    information_box: information_box,

    reference_signs: reference_signs,

    page_numbering: page_numbering,
    
    {
      // Add the date line, if any.
      if date != none {
        align(right, date)
        v(0.65em)
      }
      
      // Add the subject line, if any.
      if subject != none {
        pad(right: 10%, strong(subject))
        v(0.65em)
      }
      
      set par(justify: true)
      body
    },

    margin: margin,
  )
}
