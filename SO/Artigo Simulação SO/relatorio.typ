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
#set page(
  paper: "a4",
  numbering: "1",
  number-align: right,
  margin: (
    top: 3.5cm,
    bottom: 2.5cm,
    left: 3cm,
    right: 3cm
  )
)
#set list(indent: 3em)
#set heading(
  numbering: numbering(
    (..nums) => nums
      .pos()
      .map(str)
      .join("."),
    1,1
  )
)

#show link: set text(hyphenate: true)

#set figure.caption(separator: ". ")
#show figure.caption: it => {
  set text(font: "Helvetica", size: 10pt)

  strong[#it.supplement #it.counter.display(it.numbering)]
  it.separator
  strong[#it.body]
  v(6pt)
}

#show heading: self => [
  #self
  #v(15pt)
]

#align(center)[
  #text(size: 18pt)[
    *Simulação de gerenciamento de memória com algorítmos First-Fit e Worst-Fit*
  ]
  #text(size: 12pt)[

    *Adolfo Fernando Silva Araújo*

    *Alana Brenda Pantoja dos Santos*

    *Lucas de Oliveira Alves*

    *Nalanda Vitória Silva Melo*
  ]

  Universidade Feredal do Sul e do Sudeste do Pará

  #text(font: "Nimbus Mono PS")[
    aadolfofernando\@unifesspa.edu.br

    alanabrenda003\@unifesspa.edu.br

    lucas.oalves\@unifesspa.edu.br

    nalandamelo\@unifesspa.edu.br
  ]
]

= Introdução

Este relatório abordará o tema do desenvolvimento da aplicação "SimuladorMem", desenvoldida com o objetivo de
demonstrar a gerencia de memória feita com os algorímtmos *First-Fit* e *Worst-Fit*.
Ambos são algorítmos para alocação de memória por programas de computador, sendo o First-Fit o "Primeiro ajuste",
e Worst-Fit o "pior ajuste".

Este documento esta dividido em 3 partes. "Os Algorítmos" é uma rápida explicação sobre os algorítmos abordados e como eles funcionam, "Software Desenvoldido" é onde apresentamos nossa aplicação que simula a execução dos algorítmos de alocação, e por fim "Conclusão" apresenta a parte final, demonstrando pontos sobre cada algorítmo e como o desenvolvimento da aplicação contribuiu para o aprendizado a respeito do assunto.

= Os Algorítimos

Computadores são sistemas dinâmicos, onde programas de computador precisam ser armazenados temporariamente em um dispositivo
chamado *Memória de Acesso Aleatório*, ou _memória RAM_. O sistema operacional é responsável por carregar os softwares solicitados
pelo usuário para a memória RAM, e descarregá-lo quando o usuário fechar o software. Assim surge o grande: com o tempo, nesse
carrega-descarrega, espaços livres podem ser deixados na memória, gerando o fenômeno chamado de fragmentação.

Um exemplo disso pode ser visto em @fig-frag, onde em (a), (b) e (c) ocorre o carregamento de programas na memória, e em (d) o programa A é descarregado.
Observe que após ser descarregado, o programa A deixa uma lacuna. Quando o programa D é carregado na memória em (e), ele é alocado para este espaço, porém ele também poderia (se ainda tivesse espaço) ser alocado no pedaço de memória acima de C. Quem escolhe em que bloco de memória o processo sera alocado, é o algorítmo de gerência de memória.

#figure(
  image("images/fragmentação.png"),
  caption: [Um exemplo de fragmentação [Tenanbaum 2016]]
)<fig-frag>



Com base nisso, nosso grupo abordou dois algorítmos de alocação de memória:

- *First-Fit*: O algorítmo First-Fit escolhe o primeiro bloco de memória que ele encontra. O objetivo do algorítmo é executar o mais rápido possivel, tomando pouco tempo de CPU e acelerando o processo de alocação de processos na RAM.
- *Worst-Fit*: O algorítmo Worst-Fit escolhe o maior bloco de memória que ele encontra. O objetivo do algorítmo é reduzir a fragmentação, diminuindo a quantidade de blocos de memória pequenos. Porém, ele é chamado de "_pior escolha_" por apresentar um tempo muito alto de execução, e ainda aumentar a fragmentação de forma mais rápida, pois os grandes blocos de memória se esgotam mais rápido.

= Software Desenvoldido

A partir dos conteúdos, nossa equipe desenvolveu o software _SimuladorMem_, um programa simples capaz de simular os algorítmos de gerência de memória First-Fit e Worst-Fit. Em @fig-tela1, é possível ver a tela inical da aplicação. Observe que do lado direito existem 4 botões:

- *Criar processo*: permite criar um novo processo, escolhendo um nome, um tamanho e uma cor para o processo, conforme é possível ver em @fig-tela-criar-p.
- *Deletar processo*: permite apagar um processo, como pode ser visto em @fig-tela-deletar-p.
- *Coalescencia*: realiza o processo de coalescencia nos blocos de memória, unindo blocos de memória livre adjacentes.
- *Realocar processos*: realiza a realocação de processos, criando um único bloco de memória livre no final da memória.

#figure(
  image("images/1.png"),
  caption: [Imagem da tela inicial da aplicação, sem nada executando ainda]
)<fig-tela1>

#figure(
  image("images/7.png"),
  caption: [Tela de criação de processo, onde você pode atribuir nome, tamanho e cor para o processo]
)<fig-tela-criar-p>

#figure(
  image("images/8.png"),
  caption: [Tela para deletar um processo]
)<fig-tela-deletar-p>

Também existe um _toggle button_ no canto superior, que permite alternar entre os algorítmos First-Fit e Worst-Fit. No lado direito da aplicação, temos uma grade 16x16, que demonstra de forma visual a disposição dos processos na memória, veja em @fig-tela-processos. Os campos pretos indicam que aquela célula de memória não esta alocada, então quando apagamos um processo, as células que ele ocupam voltam a ficar pretas conforme em @fig-tela-processos-d.

#figure(
  image("images/2.png"),
  caption: [Representação visual dos processos na memória]
)<fig-tela-processos>

#figure(
  image("images/3.png"),
  caption: [Processos após um processo ser deletado]
)<fig-tela-processos-d>

O software está disponível no Github, #link("https://github.com/Naosousenior/UNIFESSPA/tree/7c69b168d77c912d2849368c410cc6c4f5f18256/SO/SimuladorMem/simuladormem")[#underline("neste link")].

= Conclusão

Durante o desenvolvimento do simulador, foi possível compreender as necessidades que cada algorítmo atende. First-Fit funciona melhor em sistemas que exigem velocidade, resposta com baixa latência, e é o algorítmo mais utilizado na maioria dos casos. Worst-Fit, sengundo @tanenbaum, é apenas mais lento e menos eficiênte, sende pouco aplicável em sistemas práticos. É importante observar que existe um terceiro algorítmo, não abordado por nossas equipe, chamado _Best-Fit_

#bibliography("referencias.yaml", style: "associacao-brasileira-de-normas-tecnicas")