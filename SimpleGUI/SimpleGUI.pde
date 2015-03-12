//ControlP5 library by Andreas Schlegel - http://www.sojamo.de/libraries/controlP5/
//Serial selection dropdown list made by Dumle29 (Mikkel Jeppesen) for processing
//saveData.pde Data utility by Marius Watz - http://workshop.evolutionzone.com
// 
//All other code by Tabor Henderson
//Released under GNU GPL and CC SA 3.0 where applicable

import processing.serial.*;
import controlP5.*;

ControlP5 cp5;
Accordion guiAccordion;
String textValue = "";
Textarea messageArea;
Textarea calibrationMessage;
Textarea logSetupMessage;
Textfield distCalEntry;
Textfield xlCalX;
Textfield xlCalY;
Textfield xlCalZ;
CheckBox calSignsCheckBox;

Data data;                       // The data file stream
DropdownList ports;              //Define the variable ports as a Dropdownlist.
CheckBox sensorCheckBox;         //The sensor selection checkboxes

Serial port;                     //Define the variable port as a Serial object.
int Ss;                          //The dropdown list will return a float value, which we will connvert into an int. we will use this int for that).
String[] comList ;               //A string to hold the ports in.
boolean serialSet;               //A value to test if we have setup the Serial port.
boolean Comselected = false;     //A value to test if you have chosen a port in the list.

String statusString;             // Status message
String calibrationString;        // Calibration status message
String logSetupString;           // Data log setup status message
String fileName = "data";        // Default data log file header
String selectedFolder;           // User-selected data folder
int inVal = 0;                   // Input value from serial port
String logData = "";             //String for catching all serial output
int logStartTime = 0;            // Integer log start time variable to give us cleaner logs
int[] calSigns = {
  1, 1, 1, 1
};                               // Calibration signs
int lf = 10;                     // ASCII linefeed

int timeBuffer=0;
float thetaBuffer=0.1;
float phiBuffer=0.1;
float gammaBuffer=0.0;
float gammaPrimeBuffer=0.1;
float alphaBuffer = 0.5;
boolean firstContact = false;    // Whether we've heard from the microcontroller
boolean logging = false;

float xpos =0;
int msExt = 0;                   // Integer for the Arduino timestamp
int distVal = 0;                 // Input value for ping distance
int distCal = 0;                 // Distance calibration value
float[] xlVals = {
  0, 0, 0
};                               // Input values for accelerometer
float[] xlCals = {
  0, 0, 0
};  

void setup() {  
  size(240, 400, P3D);//240
  PFont font = createFont("arial", 20);
  gui();  //build the GUI - see file 'gooey'
  setupCOMport(ports);
  selectFolder("Select a folder to save data in:", "folderSelected");
  textFont(font);
}

void startSerial(String[] theport)
{
  //When this function is called, we setup the Serial connection with the aquired values. The int Ss acesses the determins where to accsess the char array. 
  port = new Serial(this, theport[Ss], 9600);
  //Since this is a one time setup, we state that we now have set up the connection.
  serialSet = true;
  port.bufferUntil(lf);
  statusString = "COM port selected, waiting for input. If message persists for more than thirty seconds, check connection and restart Simple.";
  messageArea.setText(statusString);
}

void draw() {
  //So when we have chosen a Serial port but we havent yet setup the Serial connection. Do this loop
  while (Comselected == true && serialSet == false)
  {
    //Call the startSerial function, sending it the char array (string[]) comList
    startSerial(comList);
  }  
  background(0);
  //text(cp5.get(Textfield.class, "fileName").getText(), 360, 130);
  //text(statusString, 10, 250);
  messageArea.setText(statusString);
  if (Comselected == true && serialSet == true) {
    fill(0, 255, 0);  
    xpos = map(distVal, 30, 3000, 20, 220);
    //println(xpos);
    if (logging == true) {
      //check checkbox status, use it to decide which data to save
      float[] dataChoice = sensorCheckBox.getArrayValue();
      String newDataLine = "";
      if (dataChoice[0] == 1.0) {
        int hostTime = millis()-logStartTime;
        newDataLine = newDataLine + hostTime;
      };
      if (dataChoice[1] == 1.0) {
        newDataLine = newDataLine +", " + msExt;
      };
      if (dataChoice[2] == 1.0) {
        newDataLine = newDataLine +", " + distVal;
      };
      if (dataChoice[3] == 1.0) {
        newDataLine = newDataLine +", " + xlVals[0]+", "+xlVals[1]+", "+xlVals[2];
      }; 
      // data.add(millis()-logStartTime+", "+msExt+", "+distVal+", "+xlVals[0]+", "+xlVals[1]+", "+xlVals[2]);  
      data.add(newDataLine); // Write the coordinate to the file
    }
    rect(20, 360, xpos, 20);
    port1.write('K');       // ask for data
  }
  if (msExt != 0) {
    println("alphaBuffer: "+alphaBuffer);
    int dt = abs(1+msExt-timeBuffer);
    float RC = dt*(1.0-alphaBuffer)/alphaBuffer;
    float alpha = dt/(dt+RC);
    alphaBuffer = alpha;
    println("alpha: "+alpha+", timeBuffer: "+timeBuffer+", dt: "+dt+", RC: "+RC);
    timeBuffer = msExt;
    println("new timeBuffer: "+timeBuffer);
    pushMatrix();
    translate(170, 320, 0);
    float theta = atan(xlVals[1]/xlVals[2]);
    float phi =  atan(xlVals[0]/xlVals[2]);
    float gammaPrime = xlVals[1]*dt/10000+gammaPrimeBuffer;
    float gamma = ((dt^2)*xlVals[1])/1000+gammaPrime*dt/10000+gammaBuffer;
    println("theta: "+theta+", phi: "+phi+", gamma: "+gamma);
    //rotateY(lowPass(gammaBuffer, gamma, alpha));
    //rotateY(alpha*gamma + (1-alpha)*gammaBuffer);
    gammaBuffer = gamma;
    gammaPrimeBuffer = gammaPrime;
    //rotateX(alpha*theta + (1-alpha)*thetaBuffer);
    rotateX(lowPass(thetaBuffer, theta, alpha));
    thetaBuffer = theta;
    //rotateZ(alpha*phi+ (1-alpha)*phiBuffer);
    rotateZ(lowPass(phiBuffer, phi, alpha));
    phiBuffer = phi;
    //noFill();
    color(255, 255, 0);
    stroke(255);
    box(40);
    popMatrix();
  }
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
      p.write("A");
    }
  } else {
    logData = p.readStringUntil(lf);
    String[] inputData = split(logData, ',');
    distVal = Integer.parseInt(inputData[1].trim()) + distCal*calSigns[0];
    msExt = Integer.parseInt(inputData[0].trim());
    xlVals[0] = xlCals[0]*calSigns[1] + Integer.parseInt(inputData[2].trim()) * 0.0078;
    xlVals[1] = xlCals[1]*calSigns[2] + Integer.parseInt(inputData[3].trim()) * 0.0078;
    xlVals[2] = xlCals[2]*calSigns[3] + Integer.parseInt(inputData[4].trim()) * 0.0078;
    /*
    //if we've already heard from the controller, we 
     //know we're receiving numbers, so save as such
     //but we don't know how many digits, and we have
     //to convert from ASCII, so it's loopy time
     byte[] inBuffer = p.readBytes();
     boolean multiPoint = false;
     if (inBuffer != null) {
     //println(inBuffer);
     inVal = 0;
     int bufferLength = inBuffer.length;
     for (int i=0; i < bufferLength-2; i++) {
     if (inBuffer[i] >= 48 && inBuffer[i] <= 57) {
     inVal = (10*inVal) + (inBuffer[i]-48);
     }
     }
     distVal = inVal; 
     //println(inVal); //print to make sure our byte conversion is remotely sane
     }*/
  }
}

float lowPass(float x_b, float x_c, float alpha) {
  float y_c = alpha*x_c + (1-alpha)*x_b;
  return y_c;
} 

