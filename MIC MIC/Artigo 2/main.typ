#import "@preview/charged-ieee:0.1.4": ieee

#show: ieee.with(
  title: [Calculadora com entrada em binário usando microcontrolador PIC16F628A],
  abstract: [
    Este trabalho apresenta o desenvolvimento de uma calculadora embarcada no PIC16F628A. O objetivo do projeto é implementação de uma dispositivo
    capaz de realizar as 4 operações básicas, com uma entrada em binário. A entrada do usuário é realizada por 3 botões, sendo dois dos botões
    para digitar o valor numérico, e um botão para trocar a operação matemática realizada. A saíde é realizada por meio de um display de 7 segmentos
    e dois LEDS.
  ],
  authors: (
    (
      name: "Adolfo Fernando Silva Araujo",
      location: [Marabá, PA - Brasil],
      email: "aadolfofernando@unifesspa.edu.br"
    ),
    (
      name: "Alana Brenda Pantoja dos Santos",
      location: [Marabá, PA - Brasil],
      email: "alanabrenda003@unifesspa.edu.br"
    ),
    (
      name: "Lucas de Oliveira Alves",
      location: [Marabá, PA - Brasil],
      email: "lucas.oalves@unifesspa.edu.br"
    ),
  ),
  bibliography: bibliography("refs.yaml", full: true),
  figure-supplement: [Figura],
  paper-size: "a4"
)

= Introdução

Desde os primórdios da humanidade, a matemática sempre foi uma das suas melhores ferramentas de trabalho. A primeira ferramenta criada pela 
humanidade para a realização de contas complexas foi sem dúvidas o ábaco, que acelerava muito o processo de soma e multiplicação. Depois, a régua 
de cálculo, uma ferramenta que funcionava com base em logarítmos, passou a facilitar as contas de divisão, potenciação e raízes também. Depois, a Pascalina, considerada a primeira calculadora mecânica, desenvolvida por Blaise Pascal, deu um novo passo a humanidade, sendo capaz de realizar cálculos automáticamente a medida que o usuário operava engrenagens.

Nos dias de hoje, temos a nossa disposição calculadoras eletrônicas de bolso, tão pequenas e compactas, porém tão poderosas que rápidas, que por
vezes esquecemos da complexidade existente por trás do desenvolvimento dessa ferramenta. Foi a partir desta análise, que uma calculadora foi
desenvolida, utilizando como componente central o PIC16F628A, um microcontrolador desenvolvido pela Microchip que foi um marco no mundo da
eletrônica, devido a sua simplicidade e poder.

O esquema do sistema está esboçado em @fig-blocos. As entradas, no lado esquerdo, são botões, e as saidas são dois LEDS e um display de 7 segmentos.

#figure(
  image("images/diagrama_blocos.png"),
  caption: [Diagrama de blocos da calculadora. Do lado esquerdo temos os componentes de entrada, e do lado direito as saídas.]
)<fig-blocos>

= Metodologia

Para o desenvolvimento da calculadora, o software proprietário da Microchip, MPLAB, foi utilizado para codificação do firmware do PIC.
Em conjunto a isso, o software livre SimulIDE foi utilizado para realizar simulações com o firmware, antes de tentar levar para a protoboard. A linguagem de programação utilizada para o desenvolvimento do projeto foi C, com o compilador da Microchip XC8.

Devido as limitações do PIC16F628A, foi identificada a necessidade de reduzir o número de entradas. Por este motivo, utilizou-se 3 botões,
conforme é possivel ver em @fig-blocos. Em @fig-esquema é possivel visualizar como o circuito ficou esquematizado, com @tab-pinos sendo uma
relação entre os pinos do PIC, os componentes de E/S e as funções de cada um.

#figure(
  image("images/esquema_circuito.png"),
  caption: [Esquema do circuito eletrônico da calculadora, recorte de tela da simulação da aplicação SimulIDE.]
)<fig-esquema>

#figure(
  table(
    columns: (auto, auto, auto),
    inset: 10pt,
    align: horizon,
    table.header(
      [*Pino*], [*Componente*], [*Descrição*]
    ),
    [RA0],[LED 1],[LED que indica que o usuário ainda esta digitando o primeiro número],
    [RA1],[Botão 0], [Botão que insere um bit 0 a esquerda no número atual],
    [RA3], [LED 2], [LED que indica que o usuário esta digitando o segundo númeor],
    [RA5], [Botão de troca de operação], [Botão para trocar a operação a ser realizada pela calculadora],
    [RA7], [Botão 1], [Botão que insere um bit 1 a esquerda no número atual],
    [RB0-RB7], [Display de 7 segmentos], [Display onde são exibidos os algarísmos dos números e a operação selecionada atualmente]
  ),
  caption: []
)<tab-pinos>

Como é possivel perceber, a entrada deve ser realizada em binário. Ao ligar, o PIC exibe no display a operação padrao iniciada, que no caso é a
operação de soma. As operações disponíveis são de soma, subtração, multiplicação e divisão, e cada uma possui um símbolo que será exibido no
display quando a operação for selecionada (@tab-op). Ao clicar no botão de troca de operação, o PIC exibirá a operação atual brevemente, e depois
voltará para o que estava sendo exibido antes.

O PIC esperará até que algum botão de bit seja pressionado, para começar a escrita dos valores. Cada valor possui 8 bits, ou seja, são núemeros
de até 1 byte, que não podem ser negativos, sendo assim, é possível escrever valores de 0 a 255. Como só há um display disponível, cada algarísmo
sera exibido por vez, de trás para frente, ou seja, se você digitar o número 5, que tem forma binária _101_, você deve começar apertando o
botão 1. Ao fazer isso, a calculadora exibirá no display os algarísmos `1, 0` e `0`. Depois, ao apertar o botão 0 aparecerá `1, 0` e `0` novamente, mas ao apertar o botão 1 novamente, aparecerá `5`, `0` e `0`. Isto porque, cada vez que você apertar em um botão, a calculadora exibirá o valor atual do registrador que guarda aquele número, e cada vez que você digita um bit, esse bit vai para sua respectiva posição no
registrador. Isso também significa que, após digitar `101` no PIC, vocẽ deve continuar digitando _0s_, ate completar _00000101_ no registrador. Só após digitar 8 bits, a calculadora entenderá que você terminou de digitar o valor.

#figure(
  table(
    columns: (auto,auto),
    inset: 10pt,
    align: horizon,
    table.header([*Simbolo*],[*Operação*]),
    image("images/soma_op.png"), [Soma],
    image("images/sub_op.png"), [Subtração],
    image("images/mul_op.png"), [Multiplicação],
    image("images/div_op.png"), [Divisão]
  ),
  caption: [Significado de cada símbolo de operação no display]
)<tab-op>

Justamente por este motivo, temos o uso dos LEDs nas portas `RA0` e `RA3` do PIC. Os LEDs indicam qual número você está digitando, e indicam
também se o PIC está exibindo um resultado. Ao clicar nos botões 0 ou 1 pela primeira vez, o primeiro LED se acenderá. Enquanto ele permanecer
aceso, a calculadora estará indicando que o primeiro valor está sendo digitado. Ao digitar o 9º bit, o PIC trocará do primeiro LED para o
segundo, indicando que a partir de agora o usuário está digitando o segundo valor. Observe que o valor digitado no 9º bit não será utilizado, e
servirá apenas para indicar ao usuário que a variável que ele esta editando mudou. Então, o 10º bit é o primeiro bit, da direita para esquerda,
do segundo valor, e a lógica explicada anteriormente também vale para este valor.

Após digitar o 18º bit, o PIC acenderá os dois LEDs, indicando que ele está exibindo o resultado. Como a operação de multiplicação entre dois
números de 3 dígitos decimais pode resultar em valores de até 5 dígitos decimais, o resultado é exibido 5 dígitos por vês, novamente de trás para
frente. Ou seja, para exibir o valor `10059`, a calculadora exibiria `9`,`5`,`0`,`0` e `1` por vez. Após exibir todos os 5 digitos, a calculadora
voltaria para o estágio inicial, e iria esperar pela próxima operação.

Para demonstrar, este é o código para exibir o valor de um número de 3 bits do firmware:

#v(10pt)

```c
void exibir_num(num valor) {
    num digito;
    num i = 1;
    
    while(1) {
        digito = (valor % (i*10))/(i); // descubro o valor do digito descubro o valor do digito de forma unitaria
        valor -= digito*(i);
        
        set_valor_display(digito);
        __delay_ms(1000);
        PORTB = 0x00;
        __delay_ms(250);
        
        if(i == 100) {
            break;
        }
        i *= 10;
    }
}
```

#v(10pt)

Sendo que o tipo `num` é definido no início do programa como:

#v(10pt)

```c
typedef unsigned char num;
```

#v(10pt)

Observe que somente três variáveis são utilizadas: `digito`, `valor` e `i`. A cada algarísmo utilizado, o valor é descontado dele. Isso é para
facilitar o cálculo do próximo dígito, e economizar o espaço de RAM do PIC. Observe também que i não é exatamente um contador, ele está mais
para uma exponencial de 10, servindo como máscara para calcular o valor de cada dígito.

Adicionalmente, também temos a função `mostrar_resultado`, que calcula o resultado e exibe ele no display:

#v(10pt)

```c
void mostrar_resultado() {
    num digito;
    unsigned int i = 1;
    unsigned int resultado;
    
    switch(op) {
    case soma:
        resultado = valor1+valor2;
        break;
    case sub:
        resultado = valor1-valor2;
        break;
    case mul:
        resultado = valor1*valor2;
        break;
    case div:
        resultado = valor1/valor2;
        break;
    }
    
    while(1) {
        digito = (resultado % (i*10))/(i); // descubro o valor do digito descubro o valor do digito de forma unitaria
        resultado -= digito*(i);
        
        set_valor_display(digito);
        __delay_ms(3000);
        PORTB = 0x00;
        __delay_ms(500);
        
        if(i == 10000) {
            bit_atual = 0;
            valor1 = 0;
            valor2 = 0;
            op = soma;
            
            LED1 = 0;
            LED2 = 0;
            break;
        }
        i *= 10;
    }
}
```

#v(10pt)

A lógica de exibir o resultado no display é a mesma, porém com 5 dígitos. Veja também que o resultado é um `unsigned int`, pois o valor pode exceder um número de apenas 8 bits facilmente.

= Resultados Obtidos

Após passar nos testes do simulador, o circuito foi montado e utilizado em uma protoboard. Como esperado, ele funcionou corretamente exibindo os
resultados das operações corretamente, na maioria dos casos. As exceções foram apenas nos casos onde:

- O resultado era muito grande, por exemplo, a multiplicação $250 * 250$ sempre exibia um valor aleatório.
- A subtração dava um valor negativo, gerando um estouro na memória e levando para valores altos.
- Divisão por 0, que exibe como resultado apenas 0.

No restante dos casos, a calculadora cumpria bem seu papel, exibindo o resultado corretamente, mesmo que pausadamente.

= Conclusão

A implementação de uma calculadora com um microcontrolador como o PIC16F628A se mostrou desafiadora, mas não impossível, em especial no quesito
interação com o usuário. Entretanto, o aprendizado obtido com o processo de montagem, teste e remontagem se mostrou gratificante. Todo o processo
de escolhas, como reduzir o número de variáveis para exibição do PIC, e até mesmo exibir os valores com um único display apenas mostrando dígito
a dígito pausadamente, contribuiu para uma nova visão a respeito da montagem de sistemas embarcados e planejamento de sofware no baixo nível.
Assim sendo, a calculadora se mostrou uma ótima ferramenta para o aprendizado e desenvolvimento humano até mesmo nos dias onde cálculos complexos
são realizados milhares de vezes por segundos em supercomputadores ao redor do mundo todo.

= Apêndice

O vídeo de demonstração de uso da calculadora está disponível #link("https://drive.google.com/file/d/1S3PHxWIJ8cpm6qIWs_eGqoUtsb2F_Zzl/view?usp=drive_link")[#underline("aqui")].

O arquivo binário do firmware está #link("https://drive.google.com/file/d/1hLreXXDMKJbKcYsZq-toU_OyELeu1S8B/view?usp=drive_link")[#underline("aqui")].

O código fonte do programa está disponível #link("https://drive.google.com/file/d/11UiAVIigTn1DgyE8OtG5wmqYCuNYM2Oo/view?usp=drive_link")[#underline("neste link")].