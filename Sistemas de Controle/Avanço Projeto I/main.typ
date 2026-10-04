#import "@preview/charged-ieee:0.1.4": ieee

#show: ieee.with(
  title: [Sistema de controle de alimentos para gatos],
  abstract: [
    A alimentação de animais domésticos é uma tarefa que deve ser realizada com boa frequência, como forma de manutenção a cuidado da saúde destes. Aqui, abordaremos um sistema para automatizar a entrega de ração para gatos, entregando certa quantidade de ração quando que estes miarem próximo de suas vasilhas de comida. O sistema também contará com um mecânismo de "time wait", com o objetivo de evitar que o animal extrapole um limite de ração por hora definido.
  ],
  authors: (
    (
      name: "Adolfo Fernando Silva Araújo",
      organization: [Universidade Federal do Sul e do Sudeste do Pará],
      email: "aadolfofernando@unifesspa.edu.br"
    ),
    (
      name: "Alana Brenda Pantoja dos Santos",
      organization: [Universidade Federal do Sul e do Sudeste do Pará],
      email: "alanabrenda003@unifesspa.edu.br"
    ),
    (
      name: "Lucas de Oliveira Alves",
      organization: [Universidade Federal do Sul e do Sudeste do Pará],
      email: "lucas.oalves@unifesspa.edu.br"
    ),
  ),
  //bibliography: bibliography("refs.bib"),
  figure-supplement: [Fig.],
  index-terms: ("Sistemas de controle", "Automação", "Pets", "Micro-controladores")
)

= Introdução

Abaixo, o diagrama de blocos do sistema de controle de pragas.

#figure(
  image("imagens/block_diagram.png")
)
