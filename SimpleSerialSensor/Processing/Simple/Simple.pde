import processing.serial.*;
import controlP5.*;

ControlP5 cp5;
String textValue = "";
Textarea messageArea;

Serial p;    // The serial port
Data data;  // The data file stream

String statusString;  // Status message
String fileName = "data"; // Data log file header
int inVal = 0;        // Input value from serial port
int lf = 10;      // ASCII linefeed
float xpos;
boolean firstContact = false;        // Whether we've heard from the microcontroller
boolean logging = false;

void setup() {  
  size(240, 400);//240
  PFont font = createFont("arial", 20);
  cp5 = new ControlP5(this);
  // File name input area
  cp5.addTextfield("fileName")
    .setPosition(20, 20)
      .setSize(200, 40)
        .setFont(font)
          .setFocus(true)
            .setColor(color(255, 0, 0))
              ;
  // Finish logging button           
  cp5.addBang("finishLog")
    .setPosition(125, 75)
      .setSize(95, 40)
        .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
          ; 
  // Start logging button
  cp5.addBang("startLog")
    .setPosition(20, 75)
      .setSize(95, 40)
        .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
          ; 
  // Message area
  messageArea = cp5.addTextarea("txt")
    .setPosition(20, 130)
      .setSize(200, 100)
        .setFont(createFont("arial", 12))
          .setLineHeight(18)
            .setColor(color(128))
              .setColorBackground(color(255, 100))
                .setColorForeground(color(255, 100));
  ;
  statusString = "Waiting for input; if message persists for more than thirty seconds, check connection and restart Simple.";
  messageArea.setText(statusString);

  textFont(font);

  // List all the available serial ports:
  println(Serial.list());
  // Open the port you are using at the rate you want:
  p = new Serial(this, Serial.list()[2], 9600);
  p.bufferUntil(lf);
}

void draw() {
  background(0);
  //text(cp5.get(Textfield.class, "fileName").getText(), 360, 130);
  //text(statusString, 10, 250);
  messageArea.setText(statusString);
  if (inVal <= 30){
    fill(255, 255, 0);
    xpos = inVal;
  }
  else if (inVal <= 700) {
    fill(0,255,0);
    xpos = map(inVal, 30, 700, 20, 150);
  } else {
    fill(0,0,255);
    xpos = map(inVal, 701, 3500, 150, 220);
  }
  //println(xpos);
  if (logging == true) {
    data.add(inVal);  // Write the coordinate to the file
  }
  rect(20, 360, xpos, 20);
  p.write('D');       // ask for a distance
}

void serialEvent(Serial p) {
  // if this is the first byte received, and it's an A,
  // clear the serial buffer and note that you've
  // had first contact from the microcontroller. 
  // Otherwise, add the incoming byte to the array:
  if (firstContact == false) {
    // read a byte from the serial port:
    char inByte = char(p.read());
    if (inByte == 'A') { 
      p.clear();          // clear the serial port buffer
      firstContact = true;     // you've had first contact from the microcontroller
      statusString = "Receiving data, ready to log"; 
      p.write("C");
    }
  } else {
    //if we've already heard from the controller, we 
    //know we're receiving numbers, so save as such
    //but we don't know how many digits, and we have
    //to convert from ASCII, so it's loopy time
    byte[] inBuffer = p.readBytes();
    if (inBuffer != null) {
      //println(inBuffer);
      inVal = 0;
      int bufferLength = inBuffer.length;
      for (int i=0; i < bufferLength-2; i++) {
        if (inBuffer[i] >= 48 && inBuffer[i] <= 57) {
          inVal = (10*inVal) + (inBuffer[i]-48);
        }
      }
      //println(inVal); //print to make sure our byte conversion is remotely sane
    }
  }
}

