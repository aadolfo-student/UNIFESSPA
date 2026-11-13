#import "@preview/charged-ieee:0.1.4": ieee

#show: ieee.with(
  title: [Self balance: lutando contra a gravidade para se manter de pé],
  abstract: [
    Este trabalho tem por objetivo apresentar o robô "self balance", um dispositivo eletromecânico capaz de se manter de pé, equilibrado em duas rodas, apenas ajustando a velocidade e a direção
    do giro das rodas. O sistema conta com um ESP32 como cérebro, e dois motores com caixa de redução 3\~6 volts, um giroscópio e um acelerômetro. A partir da leitura dos sensores, o ESP calcula em
    tempo real a força e a direção para o qual os motores devem trabalhar, garantindo que o autômato permaneça na vertical.
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
  index-terms: ("Sistemas de controle", "Automação", "Equilíbrio", "Micro-controladores")
)

= Introdução



Abaixo, o diagrama de blocos do sistema eletromecânico de equilíbrio.

#figure(
  image("imagens/block_diagram.png")
)

Adicionalmente, também desenvolvemos o esquemático do circuito eletrônico:

#figure(
  image("imagens/schematic.png")
)

#bibliography("references.yaml", full: true)
