#define LED 7
#define BUZZER 9

String texto;

const unsigned char get_codigo(char letra) {
  switch (letra) {
    case 'a': return (unsigned char) 1;
    case 'b': return (unsigned char) 2;
    case 'c': return (unsigned char) 3;
    case 'd': return (unsigned char) 4;
    case 'e': return (unsigned char) 5;
    case 'f': return (unsigned char) 6;
    case 'g': return (unsigned char) 7;
    case 'h': return (unsigned char) 8;
    case 'i': return (unsigned char) 9;
    case 'j': return (unsigned char) 10;
    case 'k': return (unsigned char) 11;
    case 'l': return (unsigned char) 12;
    case 'm': return (unsigned char) 13;
    case 'n': return (unsigned char) 14;
    case 'o': return (unsigned char) 15;
    case 'p': return (unsigned char) 16;
    case 'q': return (unsigned char) 17;
    case 'r': return (unsigned char) 18;
    case 's': return (unsigned char) 19;
    case 't': return (unsigned char) 20;
    case 'u': return (unsigned char) 21;
    case 'v': return (unsigned char) 22;
    case 'w': return (unsigned char) 23;
    case 'x': return (unsigned char) 24;
    case 'y': return (unsigned char) 25;
    case 'z': return (unsigned char) 26;
    case ' ': return (unsigned char) 27;
  }
}

void to_morse(String texto) {
  unsigned int i, j;

  for(i = 0; i<texto.length(); i++) {
    char letra = get_codigo(texto.charAt(i));

    for(j = 0; j<5; j++) {
      digitalWrite(LED, (letra & (0b00000001 << j)) ? HIGH:LOW);

      tone(BUZZER, j ? 400 : 130, 2000);
    }
  }

  digitalWrite(LED, LOW);
}

void setup() {
  // put your setup code here, to run once:

  //popular_tabela();

  pinMode(LED, OUTPUT);
  pinMode(BUZZER, OUTPUT);

  Serial.begin(9600);

  Serial.setTimeout(15000);
}

void loop() {
  // put your main code here, to run repeatedly:
  texto = Serial.readStringUntil('\n');

  if(!texto.equals(String(""))) {
    to_morse(texto);
  }
}
