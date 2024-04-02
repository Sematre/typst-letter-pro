#import "@preview/letter-pro:2.0.0": letter-simple

#show: letter-simple.with(
  sender: (
    name: "Jane Smith",
    address: "Universal Exports, 1 Heavy Plaza, Morristown, NJ 07964",
    extra: [
      (312) 555-0690
    ]
  ),
  
  recipient: [
    Mr. John Doe\
    Acme Corp.\
    123 Glennwood Ave\
    Quarto Creek, VA 22438
  ],

  reference-signs: (
    ([Hello], [World!]),
  ),
  
  date: "Morristown, June 9th, 2023",
  subject: lorem(10),
)

Dear Joe,

#lorem(100)

Best,
#v(1cm)
Jane Smith\
Regional Director
