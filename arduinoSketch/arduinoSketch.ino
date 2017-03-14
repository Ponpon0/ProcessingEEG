//includes the stepper motors librairy
#include <Stepper.h>

//number of steps it takes to make one revolution for the motor
const int stepsPerRevolution = 200;
//speed of rotation of the motor
int SPEED = 10;

int incomingVal[5] = {0}; // Data received from the serial port


int ledPin = 13; // Set the pin to digital I/O 13
int msgID = 0;
int msgState = 0;
int msgType;
int msg;
boolean inSink = false;

//counts the number of steps the motor has turned, starts from the bottom
//(from 0 to 32 to grow the tree, from 32 to 0 to make it go down)
int stepCount = 0;
//thus, sets the up and down value to be reached
int stepCountDown = 0;
int stepCountUp = 32;


//holds the tree state
boolean isUp = false;
// initializes the stepper library on pins 4 through 7
Stepper myStepper(stepsPerRevolution, 4, 5, 6, 7);

void setup() {
  pinMode(ledPin, OUTPUT); // Set pin as OUTPUT
  //sets pins 2 and 3 to outputs : they are connected to the two EN of the motors
  pinMode(2, OUTPUT);
  pinMode(3, OUTPUT);
  //sets the motors to a state of HIGH, so that the movement starts right away
  digitalWrite(2, HIGH);
  digitalWrite(3, HIGH);
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

void checkMotor() {
  if (msgType == '0') { //Motor Message
    //if there is enough light and the tree is not grown
    if (msg == '1') {
      //then make the tree grow:
      //1. sets the speed
      myStepper.setSpeed(SPEED);
      //and until it has reached the number of steps for the tree to be up
      while (stepCount < stepCountUp) {
        //makes the motor pull on the tree’s strings (by rotating it clockwise)
        myStepper.step(++stepCount);
      }
      //if number of steps is equal or above the limit, stops motor
      myStepper.step(0);
      //and sets the tree to be now up
      isUp = true;
    } else if (msg == '2') {
      //if number of steps is equal or below the limit, stops motor
      //myStepper.step(0);
      //if there is not enough light and the tree is up
      //    //brings the tree down, doing the inverse of before:
      //    //sets speed
      //    myStepper.setSpeed(SPEED);
      //    //and until it has reached the number of steps for the tree to be down
      //    while (stepCount > stepCountDown) {
      //      //makes the motor release the strings of the tree (by rotating it counter clockwise)
      //      myStepper.step(-(-stepCount));
      //}
      //if number of steps is equal or below the limit, stops motor
      myStepper.step(0);
      //and sets the tree to now down
      isUp = false;
    }
  }
}

