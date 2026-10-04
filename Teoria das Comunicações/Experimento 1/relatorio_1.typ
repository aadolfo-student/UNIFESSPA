#set text(
  font: "Times New Roman",
  size: 12pt,lang: "pt",
  region: "br",
)
#set par(
  first-line-indent: (amount: 2em,all: true),
  leading: 0.6em,
  spacing: 1em,
  justify: true
)
#set page(paper: "a4")
#set list(indent: 3em)
#set heading(numbering: "1.")

#show link: set text(hyphenate: true)

#show heading: self => [
  #self
  #v(15pt)
]

#show link: set text(fill: blue)
#show link: underline

#align(
  center,
  [
    #text(size: 16pt)[
      #box(
        image("images/unifesspa_logo.png"),
        height: 4cm,
      )

      UNIVERSIDADE FEDERAL DO SUL E DO SUDESTE DO PARÁ
    ]
  ]

)

#v(5cm)

#align(center)[
  #text(size: 18pt)[
    Relatório de Experimentos de Instrumementação Eletrônica:

    Osciloscópio e Gerador de Funções
  ]
]

#v(5cm)

#align(
  right,[
    Alunos:

    #upper[
      Adolfo Fernando Silva Araújo

      Alana Brenda Pantoja dos Santos

      Lucas de Oliveira Alves
    ]
  ]
)

#align(center)[
  #v(3cm)
  2026

  Marabá-PA
]
#pagebreak()


= Preparação

Conforme especificado durante as atividades no laboratório, os instrumentos utilizados estão descritos nas tabelas a seguir:

#align(center)[
  #table(
    columns: (auto, auto),
    inset: 10pt,
    align: left,
    table.header(
      [ #align(center)[*Instrumento*] ], [ #align(center)[*Quantidade*] ]
    ),
    [Gerador de funções com cabos e garras], [2],
    [Osciloscópio digital 2 canais com probes.], [1],
    [Multímetro Digital], [1]
  )

  #table(
    columns: (auto, auto, auto),
    inset: 10pt,
    align: horizon,
    table.header(
      [ #align(center)[Material] ], [ #align(center)[Especificações] ], [ #align(center)[Quantidade] ]
    ),
    [Resistor], [2k $Omega$], [1],
    [Capacitor], [150 _nF_], [1],
    [Indutor], [5,4 _mH_], [1],
    [Jumpers], [-], [20],
    [Protoboard], [-], [1]
  )
]


Com estas informações, nossa equipe realizou atividades práticas com o objetivo de aprender a utilizar os equipamentos de medida e controle de sinais elétricos.

= Parte I

A primeira parte da atividade envolveu a montagem de um circuito simples, com o gerador de sinais, um resistor, e o osciloscópio para verificar-mos o andamento dos sinais.

A medida que avaliávamos os circuitos, nossa equipe preencheu a tabela da imagem:

#align(center)[
  #figure(
    image(
      "images/unifesspa_logo.png"
    )
  )
]

As imagens registradas do osciloscópio estão disponíveis #link("https://drive.google.com/drive/folders/1xJh5HADuTjLxiSmD7_oNa16-D1PY4PD6?usp=drive_link")[aqui].

= Parte II

Na segunda parte do experimento, o circuito foi modificado para incluir um capacitor em série com o resistor, e visualizar a diferença dos sinais antes e depois do capacitor. Da mesma forma, os dados foram anotados, de acordo com a imagem a seguir.

#align(center)[
  #figure(
    image(
      "images/unifesspa_logo.png"
    )
  )
]

As imagens registradas deste experimento estão disponíveis #link("https://drive.google.com/drive/folders/1XPXFnDXqD2sO4w3pR2lr5yItXxks-xs7?usp=drive_link")[aqui];

= Conclusão

Com esta atividade, muitos conceitos de sinais foram revisados, novos conceitos foram aprendidos, e as habilidades práticas com as ferramentas de manipulação e geração de sinais foram melhor assimiladas por nossa equipe.



