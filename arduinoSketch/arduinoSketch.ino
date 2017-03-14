#include <Servo.h>

Servo myservo;
int servoPin = 9;
int pos = 0;

int pulse = 1500;
int incomingVal[5] = {0}; // Data received from the serial port


int ledPin = 13; // Set the pin to digital I/O 13
int ledPin2 = 12;
int msgID = 0;
int msgState = 0;
int msgType;
int msg;
boolean inSink = false;

void setup() {
  pinMode(ledPin, OUTPUT); // Set pin as OUTPUT
  pinMode(ledPin2, OUTPUT);
  myservo.attach(servoPin);

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
  checkMotor();
}

void checkLED() {
  if (msgType == '0') { //LED message
    if (msg == '1' || msg == '2')
    { // If 1 was received
      digitalWrite(ledPin, HIGH);
      digitalWrite(ledPin2, HIGH);// turn the LED on
      //delay(100);
      //digitalWrite(ledPin, LOW);
    } else if (msg == '0') {
      digitalWrite(ledPin, LOW);
      digitalWrite(ledPin2, LOW);// otherwise turn it off
    } else if (msg == '3') {
      digitalWrite(ledPin, HIGH); // turn the LED on
      delay(500);
      digitalWrite(ledPin, LOW);
      delay(500);
      digitalWrite(ledPin, HIGH); // turn the LED on
      delay(500);
      digitalWrite(ledPin, LOW); // turn the LED on
    }
    delay(10); // Wait 10 milliseconds for next reading
  }
}

void checkMotor() {
  if (msgType == '0') { //Motor Message
    //if there is enough light and the tree is not grown
    if (msg == '1') {
      myservo.write(100);
      Serial.print("GO!");
    } else if (msg == '2') {
      myservo.write(85);
      Serial.print("STOOOOP");
    } else if (msg == '0') {
       myservo.write(90);
    }
  }
}

