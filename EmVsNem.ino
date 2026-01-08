int redLedPin = 9;   // Pin connected to the red LED
int greenLedPin = 10; // Pin connected to the green LED

void setup() {
  Serial.begin(9600);
  pinMode(redLedPin, OUTPUT);
  pinMode(greenLedPin, OUTPUT);

  // Turn on the red light during setup
  // digitalWrite(redLedPin, HIGH);
}

void loop() {
  if (Serial.available() > 0) {
    char command = Serial.read();
    if (command == 'E') {
      // Emergency vehicle predicted, turn on green light for 5 seconds
      digitalWrite(redLedPin, LOW);
      digitalWrite(greenLedPin, HIGH);
    } else if (command == 'N') {
      // Non-emergency vehicle predicted, turn on red light for 5 seconds
      digitalWrite(greenLedPin, LOW);
      digitalWrite(redLedPin, HIGH);
    }
  }
}
