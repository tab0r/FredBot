import processing.serial.*;

Serial p;    // The serial port
Data data;  // The data file stream
String inString = "Waiting for input";  // Input string from serial port
int inVal = 0;        // Input value from serial port
int lf = 10;      // ASCII linefeed
int xpos;
boolean firstContact = false;        // Whether we've heard from the microcontroller

void setup() {
  size(400, 200);
  // List all the available serial ports:
  println(Serial.list());
  // Open the port you are using at the rate you want:
  p = new Serial(this, Serial.list()[2], 9600);
  p.bufferUntil(lf);
  data=new Data();
  data.beginSave();
}

void draw() {
  background(0);
  text(inString, 10, 50);
  xpos = inVal;
  //println(xpos);
  data.add(xpos);  // Write the coordinate to the file
  ellipse(xpos, 100, 20, 20);
  p.write('D');       // ask for a distance
}

void mouseClicked() {
  inVal = 0;
  p.write('D');       // ask for a distance
}

void keyPressed() {
  data.endSave(
  data.getIncrementalFilename(
  sketchPath("save"+
    java.io.File.separator+
    "data ####.txt")));
  exit();  // Stops the program
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
      inString = "Receiving data"; 
      p.write("D");
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
      println(inVal); //print to make sure our byte conversion is remotely sane
    }
  }
}

