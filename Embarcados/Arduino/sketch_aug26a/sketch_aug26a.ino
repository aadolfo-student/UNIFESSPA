int red_car = 8;
int yellow_car = 9;
int green_car = 10;

int red_people = 11;
int green_people = 12;

void abrir_carros() {
  digitalWrite(red_people, HIGH);
  digitalWrite(green_people, LOW);

  digitalWrite(red_car, LOW);
  digitalWrite(green_car, HIGH);
}

void fechar_carros() {
  digitalWrite(green_car, LOW);
  digitalWrite(yellow_car, HIGH);
  delay(5000);
  digitalWrite(yellow_car, LOW);

  digitalWrite(red_people, LOW);
  digitalWrite(green_people, HIGH);

  digitalWrite(red_car, HIGH);
}

void atencao() {
  int i;

  for(i = 0; i<5; i++) {
    delay(500);
    digitalWrite(green_people, HIGH);
    delay(750);
    digitalWrite(green_people, LOW);
  }

  digitalWrite(yellow_car, LOW);
}

void setup() {
  pinMode(red_car, OUTPUT);
  pinMode(yellow_car, OUTPUT);
  pinMode(green_car, OUTPUT);
  pinMode(green_people, OUTPUT);
  pinMode(red_people, OUTPUT);
}

void loop() {
  abrir_carros();
  delay(10000);

  fechar_carros();
  delay(5000);
  atencao();
}


