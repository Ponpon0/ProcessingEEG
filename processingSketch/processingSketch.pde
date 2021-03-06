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
public int msgID = '0'; //goes from 0 to 255 before restarting again
public char msgType = '0'; //message triggering LED for now
public char msg;
OscP5 oscP5;
Serial myPort;  

void setup() {
  size(480, 360);
  frameRate(30);
  smooth();
  
  for (int i = 0; i < Serial.list().length; i++) {
    println(Serial.list()[i]);
  }
  
  String portName = Serial.list()[1]; //change the 0 to a 1 or 2 etc. to match your port
  
  myPort = new Serial(this, portName, 9600);

  /* start oscP5, listening fosr incoming messages on port 7400
   make sure this matches the port in Mind Your OSCs */
  //oscP5 = new OscP5(this, 7400);

  // plug the OSC messages for the Affectiv values
  //oscP5.plug(this,"updateEngBor","/AFF/Engaged/Bored");
  //oscP5.plug(this,"updateExc","/AFF/Excitement");
  //oscP5.plug(this, "updateExcLon", "/COG/PUSH");
  //oscP5.plug(this, "updateMed", "/AFF/Meditation");
  //oscP5.plug(this, "updateLeft", "/EXP/HORIEYE");
  //oscP5.plug(this, "updateRight", "/EXP/WINK_RIGHT");
  //oscP5.plug(this, "updateBlink", "/EXP/EYEBROW");
  
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

void mousePressed() {
  updateLeft(1);
  println("MousePressed");
}

void mouseReleased() {
  updateRight(1);
}

void keyPressed() {
  updateBlink(1);
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
  
  if (left == 1 && msg != 2) {
   myPort.write('$');
   myPort.write(char(msgID));
   println(msgID);
   myPort.write(msgType);
   msg = '2';
   myPort.write(msg);
   println(msg);
   msgID++;
  }
}


public void updateRight(float theValue) {
  right = theValue;
  //println(fru);
  
  if (right == 1 && msg != 1) {
   myPort.write('$');
   myPort.write(char(msgID));
   println(msgID);
   myPort.write(msgType);
   msg = '1';
   myPort.write(msg);
   println(msg);
      msgID++;
  }
}

public void updateBlink(float theValue) {
  blink = theValue;
  //println(blink);
  
  if (blink == 1 && msg != 0) {
   myPort.write('$');
   myPort.write(char(msgID));
   println(msgID);
   myPort.write(msgType);
   msg = '0';
   myPort.write(msg);
   println(msg);
   msgID++;
  }
}