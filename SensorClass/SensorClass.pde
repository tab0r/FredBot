/* 
 Sensor class by Tabor Henderson
 Sensors are USB-connected devices triggered by a single 
 character, and return a single float. Such a device is simply
 built with Arduino.  
 
 If you're having trouble, start by making sure serialIndex is set 
 to the index of your preferred port in Serial.list(). This can be
 tricky, and will NOT be the same cross-platform. I wrote this on a
 Macintosh, so if you have one, you may not need to edit serialIndex.
 
 GNU GPL and CC BY-SA 3.0 where applicable.
 */

import processing.serial.*;

Serial port;                              // Serial port named port. Descriptive!
String inData = "No data";                // string for display data
int lf = 10;                              // newline char
int count = 0;                            // number of sensors
int serialIndex = 2;                      // EDIT ME-index of where our preferred port appears in Serial.list()
boolean firstContact;                     // so we know whether we've heard from the sensor or not
Sensor pingDistance;                      // sensor object, initialized below

void setup() {
  size(200, 200);
  println(Serial.list());
  port = new Serial(this, Serial.list()[serialIndex], 9600);       // prepare serial
  port.bufferUntil(lf);                                            // buffer until newline
  pingDistance = new Sensor('D', port, "mm");                      // create new sensor object
}

void draw() {
  pingDistance.triggerSensor();     // trigger the ping sensor
  background(0);                    // draw over the last draw()
  text(inData, 50, 50);             // write the current sensor value
}  

void serialEvent(Serial p) {
  // Handshake Protocol
  // if this is the first byte received, and it's an A,
  // clear the serial buffer and note that you've
  // had first contact from the microcontroller. 
  // Otherwise, treat it as incoming data
  if (firstContact == false) {
    // read a byte from the serial port:
    char inByte = char(p.read());
    if (inByte == 'A') { 
      p.clear();          // clear the serial port buffer
      firstContact = true;     // you've had first contact from the microcontroller
      p.write("A");
    }
  } else {
    inData = pingDistance.parseInput();
  }
}

