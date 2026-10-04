#define LED 3
#define POWER_BUTTON A2

void setup() {
  // put your setup code here, to run once:
  pinMode(LED, OUTPUT);
  pinMode(POWER_BUTTON, INPUT);
  Serial.begin(9600);
}

void loop() {
  // put your main code here, to run repeatedly:
  int input = analogRead(POWER_BUTTON);

  analogWrite(LED, input);

  Serial.print("Valor do potênciometro: ");
  Serial.print(input);
  Serial.println();

  /*
  valor máximo registrado no potenciometro: 1023
  valor mínimo registrado no potenciometro: 1
  */
}