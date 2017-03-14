char val = 3; // Data received from the serial port
 int ledPin = 13; // Set the pin to digital I/O 13
 
void setup() {
  pinMode(ledPin, OUTPUT); // Set pin as OUTPUT
   Serial.begin(9600); // Start serial communication at 9600 bps
   if (Serial) {
    Serial.print("Connecting");
  }   
}

void loop() {
  // put your main code here, to run repeatedly:
  while (!Serial.available());
  val = 3;
  while (Serial.available()) { // If data is sent,
     val = Serial.read(); // read it and store it in val
     Serial.print(val);
     delay(1);
   }

   if (val == '1') 
   { // If 1 was received
     digitalWrite(ledPin, HIGH); // turn the LED on
     //delay(100);
     //digitalWrite(ledPin, LOW);
   } else if (val == '0') {
     digitalWrite(ledPin, LOW); // otherwise turn it off
   } else if (val == '2') {
      digitalWrite(ledPin, HIGH); // turn the LED on
      delay(500);
      digitalWrite(ledPin, LOW);
      delay(500);
      digitalWrite(ledPin, HIGH); // turn the LED on
   }
   delay(10); // Wait 10 milliseconds for next reading
}
