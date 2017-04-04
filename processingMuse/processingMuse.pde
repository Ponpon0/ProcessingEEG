//
//MUSE OSC SERVER EXAMPLE
//Copyright Interaxon 2015
//
import oscP5.*;
import netP5.*;
import processing.serial.*;  

//public int lastPrint = 0;
public int currentState = 0; //0 = neutral, 1 for push, and 2 for Meditation
public int msgID = '0'; //goes from 0 to 255 before restarting again
public char msgType = '0'; //message triggering LED for now
public char msg;


boolean debug = false;
boolean beingused = false;
float Xsize = 100;
float Ysize = 100;

//OSC PARAMETERS & PORTS
int recvPort = 5000;
OscP5 oscP5;
Serial myPort;

//DISPLAY PARAMETERS
int WIDTH = 100;
int HEIGHT = 100;

void setup() {
  size(500, 500);
  frameRate(60);

  /* start oscP5, listening for incoming messages at recvPort */
  oscP5 = new OscP5(this, recvPort);


  background(0);

  for (int i = 0; i < Serial.list().length; i++) {
    println(Serial.list()[i]);
  }

  String portName = Serial.list()[1]; //change the 0 to a 1 or 2 etc. to match your port

  myPort = new Serial(this, portName, 9600);
}

void draw() {
  background(0);

  //if (beingused) {
  //  fill(255);
  //  ellipse(250, 250, Xsize, Ysize/3);
  //}
  //println(beingused);
}

void oscEvent(OscMessage msg) {
  /* print the address path and the type string of the received OscMessage */
  if (debug) {
    print("---OSC Message Received---");
    println(msg);
  }

  //if (msg.checkAddrPattern("/muse/elements/experimental/mellow")==true) {  
  //  if (msg.get(0).floatValue() == 0.0 || msg.get(0).floatValue() == 1.0) {
  //    print("Mellow not receiving correctly", "\n");
  //  } else if (msg.get(0).floatValue() > 0.70) {
  //    print("Mellow score: ", msg.get(0).floatValue(), "\n");
  //    //turnOn();
  //  } else {
  //    //turnOff();
  //  }
  //}

  if (msg.checkAddrPattern("/muse/elements/touching_forehead")==true) {  
    if (msg.get(0).intValue() == 1.0) {
      //print("placed on the head", "\n");
      turnOn();
      beingused = true;
    } else {
      turnOff();
      beingused = false;
      //print("NOT IN PLACE", "\n");
    }
  }
  
  if (msg.checkAddrPattern("/muse/elements/blink")==true) {  
    if (msg.get(0).intValue() == 1.0) {
      print("BLINKING", "\n");
    }
  }
  
    if (msg.checkAddrPattern("/muse/elements/jaw_clench")==true) {  
    if (msg.get(0).intValue() == 1.0) {
      print("JAWS", "\n");
    }
  }

  if (msg.checkAddrPattern("/muse/batt")==true) {
    if (msg.get(0).intValue() < 1500) {
      print("LOW BATTERY", "\n");
    }
  }

  //if (msg.checkAddrPattern("/muse/acc")==true) {
  //  //float firstValue = msg.get(0).floatValue();
  //  print("accelerometer X value", msg.get(0).floatValue(), "\n");
  //}

  //if (msg.checkAddrPattern("/muse/elements/experimental/concentration")==true) {  
  //  if (msg.get(0).floatValue() == 0.0 || msg.get(0).floatValue() == 1.0) {
  //    print("Concentration not receiving correctly", "\n");
  //  } else if (msg.get(0).floatValue() > 0.60) {
  //    print("Concentration score: ", msg.get(0).floatValue(), "\n");
  //    turnOn();
  //  } else {
  //    turnOff();
  //    print("Concentration score: ", msg.get(0).floatValue(), "\n");
  //  }
  //}


  //if (msg.checkAddrPattern("/muse/elements/horseshoe")==true) {
  //  if (msg.get(0).floatValue() == 1)
  //    print("connection status: Good!", "\n");
  //  else if (msg.get(0).floatValue() == 2)
  //    print("connection status: OK", "\n");
  //  else if (msg.get(0).floatValue() == 3)
  //    print("connection status: BAD", "\n");
  //}

  if (msg.checkAddrPattern("/muse/acc")==true) {
    //float firstValue = msg.get(0).floatValue();
    //print("accelerometer X value", msg.get(0).floatValue(), "\n");
    Xsize = msg.get(0).floatValue();
  }

  if (msg.checkAddrPattern("/muse/acc")==true) {
    //float firstValue = msg.get(0).floatValue();
    //print("accelerometer Y value", msg.get(1).floatValue(), "\n");
    Ysize = msg.get(1).floatValue();
  }

  
  //  
  //if (msg.checkAddrPattern("/muse/acc")==true) {
  ////float firstValue = msg.get(0).floatValue();
  //print("accelerometer Z value", msg.get(2).floatValue(), "\n");
  // }
  //
}

void turnOn() {
  myPort.write('$');
  myPort.write(char(msgID));
  //println(msgID);
  myPort.write(msgType);
  msg = '1';
  myPort.write(msg);
  //println(msg);
  msgID++;
}

void turnOff() {
  myPort.write('$');
  myPort.write(char(msgID));
  //println(msgID);
  myPort.write(msgType);
  msg = '0';
  myPort.write(msg);
  //println(msg);
  msgID++;
}


// test functions

void mousePressed() {
  turnOff();
  println("MousePressed");
}

void keyPressed() {
  turnOn();
}