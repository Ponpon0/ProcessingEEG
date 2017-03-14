 int incomingVal[5] = {0}; // Data received from the serial port

 
 int ledPin = 13; // Set the pin to digital I/O 13
 int msgID = 0; 
 int msgState = 0;
 int msgType;
 int msg;
 boolean inSink = false;
 
void setup() {
  pinMode(ledPin, OUTPUT); // Set pin as OUTPUT
   Serial.begin(9600); // Start serial communication at 9600 bps
   if (!Serial) {
    Serial.print("Connecting");
  }   

    // put your main code here, to run repeatedly:
  //while (!Serial.available());
}

void loop() {
  
}

void serialEvent() {

int cnt = 0;

  while (Serial.available()) { // If data is sent,
     delay(5);
     incomingVal[cnt++] = Serial.read(); // read it and store it in val
   }

//   for (int i = 0; i < cnt; i++) {  //checking values received
//    Serial.print(incomingVal[i]);
//   }
   
   if (incomingVal[0] == '$') {

     if (msgID == (int)incomingVal[1] ) {
      inSink = true; 
        msgID++;
      }
      msgType = incomingVal[2];
      msg = incomingVal[3]; //stores it
   }
   checkLED();
}

void checkLED() {
  if (msgType == '0') { //LED message
   if (msg == '1') 
   { // If 1 was received
     digitalWrite(ledPin, HIGH); // turn the LED on
     //delay(100);
     //digitalWrite(ledPin, LOW);
   } else if (msg == '0') {
     digitalWrite(ledPin, LOW); // otherwise turn it off
   } else if (msg == '2') {
      digitalWrite(ledPin, HIGH); // turn the LED on
      delay(500);
      digitalWrite(ledPin, LOW);
      delay(500);
      digitalWrite(ledPin, HIGH); // turn the LED on
   }
   delay(10); // Wait 10 milliseconds for next reading
  }
}

