/**
 * AffectCircles
 * by Joshua Madara, hyperRitual.com
 * demonstrates Processing + Emotiv EPOC via OSC
 * five circles grow and shrink in response to five
 * Affectiv values from EPOC: engagement/boredom; excitement; 
 * long-term excitement; meditation; frustration.
 */

import oscP5.*;
import netP5.*;
import processing.serial.*;

public float left = 0; // wink left
public float right = 0; // wink right
public float blink = 0;
public int time = 0;
public int delay = 0;
public int lastPrint = 0;
public int currentState = 0; //0 = neutral, 1 for push, and 2 for Meditation

OscP5 oscP5;
Serial myPort;  

void setup() {
  size(480, 360);
  frameRate(30);
  smooth();
  
  String portName = Serial.list()[1]; //change the 0 to a 1 or 2 etc. to match your port
  myPort = new Serial(this, portName, 9600);

  /* start oscP5, listening for incoming messages on port 7400
   make sure this matches the port in Mind Your OSCs */
  oscP5 = new OscP5(this, 7400);

  // plug the OSC messages for the Affectiv values
  //oscP5.plug(this,"updateEngBor","/AFF/Engaged/Bored");
  //oscP5.plug(this,"updateExc","/AFF/Excitement");
  //oscP5.plug(this, "updateExcLon", "/COG/PUSH");
  //oscP5.plug(this, "updateMed", "/AFF/Meditation");
  oscP5.plug(this, "updateLeft", "/EXP/WINK_LEFT");
  oscP5.plug(this, "updateRight", "/EXP/WINK_RIGHT");
  //oscP5.plug(this, "updateBlink", "/EXP/BLINK");
  
}

void draw() {
  //println(fru);
  time = millis();
  delay = time - lastPrint;  
  // draw fading background
  fill(0, 10);
  rectMode(CORNER);
  rect(0, 0, width, height);
}

void drawCircle(float affVal, int circleNo) {
  noFill();
  strokeWeight(3);
  ellipseMode(CENTER);
  stroke(color(round(map(affVal, 0, 1, 0, 255))), 10);
  float diam = map(affVal, 0, 1, 1, width/5);
  ellipse((width/6)*circleNo, height/2, diam, diam);
}

public void updateLeft(float theValue) {
  left = theValue;
  //println(fru);
  
  if (left == 1) {
   myPort.write('0');
   println("0");
  }
}


public void updateRight(float theValue) {
  right = theValue;
  //println(fru);
  
  if (right == 1) {
   myPort.write('1');
   println("1");
  }
}

//public void updateBlink(float theValue) {
  //blink = theValue;
  //println(blink);
  
  //if (blink == 1) {
   //myPort.write('2');
   //println("2");
  //}
//}