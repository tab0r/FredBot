import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.serial.*; 
import controlP5.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class SimpleGUI extends PApplet {

//ControlP5 library by Andreas Schlegel - http://www.sojamo.de/libraries/controlP5/
//Serial selection dropdown list made by Dumle29 (Mikkel Jeppesen) for processing
//saveData.pde Data utility by Marius Watz - http://workshop.evolutionzone.com
// 
//All other code by Tabor Henderson
//Released under GNU GPL and CC SA 3.0 where applicable




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
int msExt = 0;                   // Integer for the Arduino timestamp
int distVal = 0;                 // Input value for ping distance
int distCal = 0;                 // Distance calibration value
float[] xlVals = {
  0, 0, 0
};                               // Input values for accelerometer
float[] xlCals = {
  0, 0, 0
};                               // Calibration values for accelerometer
int[] calSigns = {
  1, 1, 1, 1
};                               // Calibration signs
int lf = 10;                     // ASCII linefeed
float xpos =0;
int timeBuffer=0;
float thetaBuffer=0.1f;
float phiBuffer=0.1f;
float gammaBuffer=0.0f;
float gammaPrimeBuffer=0.1f;
float alphaBuffer = 0.5f;
boolean firstContact = false;    // Whether we've heard from the microcontroller
boolean logging = false;

public void setup() {  
  size(240, 400, P3D);//240
  PFont font = createFont("arial", 20);
  gui();
  setupCOMport(ports);
  selectFolder("Select a folder to save data in:", "folderSelected");
  textFont(font);
}

public void gui() {
  cp5 = new ControlP5(this);

  // Note that group g0 is below to ensure the dropdown list gets rendered above other elements

    //Sensor calibration section
  Group g1 = cp5.addGroup("Sensor Calibration")
    .setBackgroundColor(color(0, 64))
      .setBackgroundHeight(290)
        ;  
  // Message area
  calibrationMessage = cp5.addTextarea("calMsg")
    .setPosition(10, 10)
      .setSize(200, 100)
        .moveTo(g1)
          .setFont(createFont("arial", 11))
            .setLineHeight(18)
              .setColor(color(255))
                .setColorBackground(color(255, 100))
                  .setColorForeground(color(255, 100));
  ;
  calibrationString = "Enter calibration values below, click for negatives";
  calibrationMessage.setText(calibrationString);        
  // Calibration signs for distance sensor
  calSignsCheckBox = cp5.addCheckBox("calSignCheckBox")
    .setPosition(10, 122)
      .setColorForeground(color(120))
        .setColorActive(color(255))
          .setColorLabel(color(255))
            .setSize(20, 5)
              .setItemsPerRow(1)
                .setSpacingColumn(30)
                  .setSpacingRow(30)
                    .setCaptionLabel("-")
                      .addItem("1", 1)
                        .addItem("2", 2)
                          .addItem("3", 3)
                            .addItem("4", 4)
                              .hideLabels()
                                .moveTo(g1)
                                  ;              
  // Calibration value for distance sensor            
  distCalEntry = cp5.addTextfield("distCalEntry")
    .moveTo(g1)
      .setPosition(35, 115)
        .setSize(60, 20)
          .setCaptionLabel("Distance Calibration")
            .setColor(color(255, 0, 0))
              ;
  distCalEntry.setInputFilter(ControlP5.INTEGER);
  // Calibration value for acceleration x-axis            
  xlCalX = cp5.addTextfield("xlCalX")
    .setPosition(35, 150)
      .setSize(175, 20)
        .setCaptionLabel("X-Axis Accelerometer Calibration")
          .setColor(color(255, 0, 0))
            .moveTo(g1)
              ;
  xlCalX.setInputFilter(ControlP5.FLOAT);
  // Calibration value for acceleration y-axis            
  xlCalY = cp5.addTextfield("xlCalY")
    .setPosition(35, 185)
      .setSize(175, 20)
        .setCaptionLabel("Y-Axis Accelerometer Calibration")
          .setColor(color(255, 0, 0))
            .moveTo(g1)
              ;
  xlCalY.setInputFilter(ControlP5.FLOAT);
  // Calibration value for acceleration z-axis            
  xlCalZ = cp5.addTextfield("xlCalZ")
    .setDecimalPrecision(10)
      .setPosition(35, 220)
        .setSize(175, 20)
          .setCaptionLabel("Z-Axis Accelerometer Calibration")
            .setColor(color(255, 0, 0))
              .moveTo(g1)
                ;  
  xlCalZ.setInputFilter(ControlP5.FLOAT);
  // Apply calibration values button
  cp5.addBang("applyCal")
    .setPosition(10, 260)
      .setSize(200, 20)
        .moveTo(g1)
          .setCaptionLabel("Apply Calibration Values")
            .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
              ; 

  // Data log setup section
  Group g2 = cp5.addGroup("Data Log Setup")
    .setBackgroundColor(color(0, 64))
      .setBackgroundHeight(200)
        ;
  // Log setup message area
  logSetupMessage = cp5.addTextarea("logMsg")
    .setPosition(10, 150)
      .setSize(200, 40)
        .moveTo(g2)
          .setFont(createFont("arial", 11))
            .setLineHeight(18)
              .setColor(color(255))
                .setColorBackground(color(255, 100))
                  .setColorForeground(color(255, 100))
                  ;
                 updateLogMessage(); 
  
  // File name input area
  cp5.addTextfield("fileName")
    .setPosition(10, 10)
      .setSize(155, 40)
        .setCaptionLabel("Enter data log filename")
          .setFont(createFont("arial", 18))
          //.setFont(font)
          .setFocus(false)
            .setColor(color(255, 0, 0))
              .moveTo(g2)
                ;
  // Change file name button          
  cp5.addBang("setName")
    .setPosition(170, 10)
      .setSize(40, 40)
        .moveTo(g2)
          .setCaptionLabel("OK")
            .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
              ; 
  // Data log entry checkboxes          
  sensorCheckBox = cp5.addCheckBox("sensorCheckBox")
    .setPosition(10, 65)
      .setColorForeground(color(120))
        .setColorActive(color(255))
          .setColorLabel(color(255))
            .setSize(15, 15)
              .setItemsPerRow(1)
                .setSpacingColumn(30)
                  .setSpacingRow(5)
                    .addItem("CPU Clock Time", 1)
                      .addItem("Sensor Clock Time", 2)
                        .addItem("Ultrasonic Distance", 3)
                          .addItem("Accelerometer", 4)
                            .activateAll()
                              .moveTo(g2)
                                ;
  // Active section
  Group g3 = cp5.addGroup("Data Logging")
    .setBackgroundColor(color(0, 64))
      .setBackgroundHeight(150)
        ;

  // Finish logging button           
  cp5.addBang("finishLog")
    .setPosition(125, 10)
      .setSize(85, 40)
        .moveTo(g3)
          .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
            ; 
  // Start logging button
  cp5.addBang("startLog")
    .setPosition(10, 10)
      .setSize(95, 40)
        .moveTo(g3)
          .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
            ; 
  // Message area
  messageArea = cp5.addTextarea("txt")
    .setPosition(10, 60)
      .setSize(200, 80)
        .moveTo(g3)
          .setFont(createFont("arial", 12))
            .setLineHeight(18)
              .setColor(color(128))
                .setColorBackground(color(255, 100))
                  .setColorForeground(color(255, 100));
  ;
  statusString = "Select COM port above!";
  messageArea.setText(statusString);

  //Sensor connect section
  Group g4 = cp5.addGroup("Sensor Connect")
    .setBackgroundColor(color(0, 64))
      .setBackgroundHeight(50)
        ;

  // Refresh ports
  cp5.addBang("refreshCom")
    .setPosition(10, 10)
      .setSize(200, 20)
        .moveTo(g4)
          .setCaptionLabel("Refresh COM Ports")
            .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
              ; 
  // List all the available serial ports:
  println(Serial.list());
  //Make a dropdown list calle ports. Lets explain the values: ("name", left margin, top margin, width, height (84 here since the boxes have a height of 20, and theres 1 px between each item so 4 items (or scroll bar).
  ports = cp5.addDropdownList("list-1", 10, 25, 200, 84)
    .setPosition(10, 50)
      .moveTo(g4);
  //Setup the dropdownlist by using a function. This is more pratical if you have several list that needs the same settings.
  customize(ports);

  // create a new accordion
  // add g1, g2, g3 and g4 to the accordion.
  guiAccordion = cp5.addAccordion("acc")
    .setPosition(10, 10)
      .setWidth(220)
        .addItem(g1)
          .addItem(g2)
            .addItem(g3)
              .addItem(g4)
                ;
  guiAccordion.open(3);
  guiAccordion.setCollapseMode(Accordion.MULTI);
}

// The dropdown list returns the data in a way, that i dont fully understand, again mokey see monkey do. 
// However once inside the two loops, the value (a float) can be achive via the used line ;). -Dumle29
// We're extending this to include a few other things -Tabor
public void controlEvent(ControlEvent theEvent) {
  if (theEvent.getName()=="list-1") 
  {
    //Store the value of which box was selected, we will use this to acces a string (char array).
    float S = theEvent.group().value();
    //Since the list returns a float, we need to convert it to an int. For that we us the int() function.
    Ss = PApplet.parseInt(S);
    //With this code, its a one time setup, so we state that the selection of port has been done. You could modify the code to stop the serial connection and establish a new one.
    Comselected = true;
  } else if (theEvent.getId()==11) {
    //calSign0.remove();
    //calSign0.setCaptionLabel("-");
  }
}

//here we setup the generic dropdown list.
public void customize(DropdownList ddl) {
  //Set the background color of the list (you wont see this though).
  ddl.setBackgroundColor(color(200));
  //Set the height of each item when the list is opened.
  ddl.setItemHeight(20);
  //Set the height of the bar itself.
  ddl.setBarHeight(15);
  //Set the lable of the bar when nothing is selected.
  ddl.captionLabel().set("Select COM port");
  //Set the top margin of the lable.
  ddl.captionLabel().style().marginTop = 3;
  //Set the left margin of the lable.
  ddl.captionLabel().style().marginLeft = 3;
  //Set the top margin of the value selected.
  ddl.valueLabel().style().marginTop = 3;
  //Set the color of the background of the items and the bar.
  ddl.setColorBackground(color(60));
  //Set the color of the item your mouse is hovering over.
  ddl.setColorActive(color(255, 128));
}

//here we setup the comList
public void setupCOMport(DropdownList ddl) {
  //Store the Serial ports in the string comList (char array).
  comList = port.list();
  //We need to know how many ports there are, to know how many items to add to the list, so we will convert it to a String object (part of a class).
  String comlist = join(comList, ",");
  //We also need how many characters there is in a single port name, we\u00b4ll store the chars here for counting later.
  String COMlist = comList[0];
  //Here we count the length of each port name.
  int size2 = COMlist.length();
  //Now we can count how many ports there are, well that is count how many chars there are, so we will divide by the amount of chars per port name.
  int size1 = comlist.length() / size2;
  //Now well add the ports to the list, we use a for loop for that. How many items is determined by the value of size1.
  for (int i=0; i< size1; i++)
  {
    //This is the line doing the actual adding of items, we use the current loop we are in to determin what place in the char array to access and what item number to add it as.
    ddl.addItem(comList[i], i);
  }
}

public void startSerial(String[] theport)
{
  //When this function is called, we setup the Serial connection with the aquired values. The int Ss acesses the determins where to accsess the char array. 
  port = new Serial(this, theport[Ss], 9600);
  //Since this is a one time setup, we state that we now have set up the connection.
  serialSet = true;
  port.bufferUntil(lf);
  statusString = "COM port selected, waiting for input. If message persists for more than thirty seconds, check connection and restart Simple.";
  messageArea.setText(statusString);
}

public void draw() {
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
    if (distVal <= 30) {
      fill(255, 255, 0);
      xpos = distVal;
    } else if (distVal <= 700) {
      fill(0, 255, 0);
      xpos = map(distVal, 30, 700, 20, 150);
    } else {
      fill(0, 0, 255);
      xpos = map(distVal, 701, 3500, 150, 220);
    }
    //println(xpos);
    if (logging == true) {
      //check checkbox status, use it to decide which data to save
      float[] dataChoice = sensorCheckBox.getArrayValue();
      String newDataLine = "";
      if (dataChoice[0] == 1.0f) {
        int hostTime = millis()-logStartTime;
        newDataLine = newDataLine + hostTime;
      };
      if (dataChoice[1] == 1.0f) {
        newDataLine = newDataLine +", " + msExt;
      };
      if (dataChoice[2] == 1.0f) {
        newDataLine = newDataLine +", " + distVal;
      };
      if (dataChoice[3] == 1.0f) {
        newDataLine = newDataLine +", " + xlVals[0]+", "+xlVals[1]+", "+xlVals[2];
      }; 
      // data.add(millis()-logStartTime+", "+msExt+", "+distVal+", "+xlVals[0]+", "+xlVals[1]+", "+xlVals[2]);  
      data.add(newDataLine); // Write the coordinate to the file
    }
    rect(20, 360, xpos, 20);
    port.write('K');       // ask for data
  }
  if (msExt != 0) {
    println("alphaBuffer: "+alphaBuffer);
    int dt = abs(1+msExt-timeBuffer);
    float RC = dt*(1.0f-alphaBuffer)/alphaBuffer;
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

public void serialEvent(Serial p) {
  // if this is the first byte received, and it's an A,
  // clear the serial buffer and note that you've
  // had first contact from the microcontroller. 
  // Otherwise, add the incoming byte to the array:
  if (firstContact == false) {
    // read a byte from the serial port:
    char inByte = PApplet.parseChar(p.read());
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
    xlVals[0] = xlCals[0]*calSigns[1] + Integer.parseInt(inputData[2].trim()) * 0.0078f;
    xlVals[1] = xlCals[1]*calSigns[2] + Integer.parseInt(inputData[3].trim()) * 0.0078f;
    xlVals[2] = xlCals[2]*calSigns[3] + Integer.parseInt(inputData[4].trim()) * 0.0078f;
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

public float lowPass(float x_b, float x_c, float alpha) {
  float y_c = alpha*x_c + (1-alpha)*x_b;
  return y_c;
} 

//BEGIN user input functions

public void applyCal() {
  // load the signs of each calibration value from calSignsCheckBox
  int[] signs = {1, 1, 1, 1};
  for (int i = 0; i<4; i=i+1) {
    if (calSignsCheckBox.getState(i) == true) {
      signs[i] = -1;
    }
  };
  
  // Check for and apply distance calibration
  if (cp5.get(Textfield.class,"distCalEntry").getText().length() >= 1) {
    distCal = signs[0]*Integer.parseInt(cp5.get(Textfield.class,"distCalEntry").getText());
    println("Changing distance calibration to "+distCal);
  }
  
  // Check for and apply X-Axis acceleration calibration
  if (cp5.get(Textfield.class,"xlCalX").getText().length() >= 1) {
    xlCals[0] = signs[1]*Float.parseFloat(cp5.get(Textfield.class,"xlCalX").getText());
    println("Changing xl X calibration to "+xlCals[0]);
  }
  
  // Check for and apply Y-Axis acceleration calibration
  if (cp5.get(Textfield.class,"xlCalY").getText().length() >= 1) {
    xlCals[1] = signs[2]*Float.parseFloat(cp5.get(Textfield.class,"xlCalY").getText());
    println("Changing xl X calibration to "+xlCals[1]);
  }
  
  // Check for and apply Z-Axis acceleration calibration
  if (cp5.get(Textfield.class,"xlCalZ").getText().length() >= 1) {
    xlCals[2] = signs[3]*Float.parseFloat(cp5.get(Textfield.class,"xlCalZ").getText());
    println("Changing xl X calibration to "+xlCals[2]);
  }
  
  calibrationString = "Current calibration values:"+PApplet.parseChar(lf)+
    "Distance: "+distCal+PApplet.parseChar(lf)+
    "X-Axis xl: "+xlCals[0]+PApplet.parseChar(lf)+
    "Y-Axis xl: "+xlCals[1]+PApplet.parseChar(lf)+
    "Z-Axis xl: "+xlCals[2]+PApplet.parseChar(lf)+
    "Enter calibration values below, click for negatives.";
  calibrationMessage.setText(calibrationString); 
}

public void startLog() {
  statusString = "Now logging data";
  messageArea.setText(statusString);
  data=new Data();
  data.beginSave();
  logging = true;
  //check checkbox status to determine what header to use
  float[] dataChoice = sensorCheckBox.getArrayValue();
  String fileHeader = "";
  if (dataChoice[0] == 1.0f) {
    fileHeader = fileHeader + "Host Clock[ms], ";
  };
  if (dataChoice[1] == 1.0f) {
    fileHeader = fileHeader + "Ext Clock[ms], ";
  };
  if (dataChoice[2] == 1.0f) {
    fileHeader = fileHeader + "Distance [mm], ";
  };
  if (dataChoice[3] == 1.0f) {
    fileHeader = fileHeader + "X-axis [g], Y-axis [g], Z-axis [g]";
  }; 
  //data.add("ms Int, ms Ext, mm, aX, aY, aZ");
  data.add(fileHeader);
  logStartTime = millis();
}

public void finishLog() {
  data.endSave(
  data.getIncrementalFilename(
  //sketchPath(
  selectedFolder+
    java.io.File.separator+
    fileName+
    " ####.txt"));//);
  statusString = "Data log saved";
  logging = false;
  //exit();  // Stops the program
}

public void fileName(String theText) {
  // automatically receives results from controller input
  println("Changing datalog name to: "+theText);
  fileName = theText;
  updateLogMessage();
}

public void setName() {
  fileName(cp5.get(Textfield.class,"fileName").getText());
}

public void refreshCom() {
  ports.clear();
  setupCOMport(ports);
}

public void folderSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    selectedFolder = selection.getAbsolutePath();
    println("User selected " + selectedFolder);
    updateLogMessage();
  }
}
  
//message area control
public void updateLogMessage() {
    logSetupString = "filepath: "+  
    selectedFolder+
    PApplet.parseChar(10)+
    "filename: "+
    fileName+
    " ####.txt";
  logSetupMessage.setText(logSetupString); 
}
/*
void referenceFunction() {
  if(key=='r') {
    myTextarea.setText("Lorem ipsum dolor sit amet, consectetur adipiscing elit."
                      +" Quisque sed velit nec eros scelerisque adipiscing vitae eu sem."
                      +" Quisque malesuada interdum lectus. Pellentesque pellentesque molestie"
                      +" vestibulum. Maecenas ultricies, neque at porttitor lacinia, tellus enim"
                      +" suscipit tortor, ut dapibus orci lorem non ipsum. Mauris ut velit velit."
                      +" Fusce at purus in augue semper tincidunt imperdiet sit amet eros."
                      +" Vestibulum nunc diam, fringilla vitae tristique ut, viverra ut felis."
                      +" Proin aliquet turpis ornare leo aliquam dapibus. Integer dui nisi, condimentum"
                      +" ut sagittis non, fringilla vestibulum sapien. Sed ullamcorper libero et massa"
                      +" congue in facilisis mauris lobortis. Fusce cursus risus sit amet leo imperdiet"
                      +" lacinia faucibus turpis tempus. Pellentesque pellentesque augue sed purus varius"
                      +" sed volutpat dui rhoncus. Lorem ipsum dolor sit amet, consectetur adipiscing elit"
                      );
                      
  } else if(key=='c') {
    myTextarea.setColor(0xffffffff);
  }
  //place in draw()
    if (keyPressed && key==' ') {
    myTextarea.scroll((float)mouseX/(float)width);
  }
  if (keyPressed && key=='l') {
    myTextarea.setLineHeight(mouseY);
  }
}
//END user input functions

// saveData.pde
// Marius Watz - http://workshop.evolutionzone.com

// Data utility
// class to save and load data from text files. 
///////////////////////////
  // SAVING 
  /*
  data.beginSave();
   data.add(s);
   data.add(a);
   data.add(b);
   data.add(x);
   data.add(y);
   data.add(bool);
   data.endSave(
   data.getIncrementalFilename(
   sketchPath("save"+
   java.io.File.separator+
   "data ####.txt")));
   */
  // LOADING  
  /*
  data.load(sketchPath("save"+
   java.io.File.separator+
   "data 0000.txt"));
   
   s=data.readString();
   a=data.readFloat();
   b=data.readFloat();
   x=data.readInt();
   y=data.readInt();
   bool=data.readBoolean(); 
   */
// DATA CLASS

class Data {
  ArrayList datalist;
  String filename, data[];
  int datalineId;

  // begin data saving
  public void beginSave() {
    datalist=new ArrayList();
  }

  public void add(String s) {
    datalist.add(s);
  }

  public void add(float val) {
    datalist.add(""+val);
  }

  public void add(int val) {
    datalist.add(""+val);
  }

  public void add(boolean val) {
    datalist.add(""+val);
  }

  public void endSave(String _filename) {
    filename=_filename;

    data=new String[datalist.size()];
    data=(String [])datalist.toArray(data);

    saveStrings(filename, data);
    println("Saved data to '"+filename+
      "', "+data.length+" lines.");
  }

  public void load(String _filename) {
    filename=_filename;

    datalineId=0;
    data=loadStrings(filename);
    println("Loaded data from '"+filename+
      "', "+data.length+" lines.");
  }

  public float readFloat() {
    return PApplet.parseFloat(data[datalineId++]);
  }

  public int readInt() {
    return PApplet.parseInt(data[datalineId++]);
  }

  public boolean readBoolean() {
    return PApplet.parseBoolean(data[datalineId++]);
  }

  public String readString() {
    return data[datalineId++];
  }

  // Utility function to auto-increment filenames
  // based on filename templates like "name-###.txt" 

  public String getIncrementalFilename(String templ) {
    String s="", prefix, suffix, padstr, numstr;
    int index=0, first, last, count;
    File f;
    boolean ok;

    first=templ.indexOf('#');
    last=templ.lastIndexOf('#');
    count=last-first+1;

    if ( (first!=-1)&& (last-first>0)) {
      prefix=templ.substring(0, first);
      suffix=templ.substring(last+1);

      // Comment out if you want to use absolute paths
      // or if you're not using this inside PApplet
      //if (sketchPath!=null) prefix=savePath(prefix);

      index=0;
      ok=false;

      do {
        padstr="";
        numstr=""+index;
        for (int i=0; i< count-numstr.length (); i++) padstr+="0";
        s=prefix+padstr+numstr+suffix;

        f=new File(s);
        ok=!f.exists();
        index++;

        // Provide a panic button. If index > 10000 chances are it's an
        // invalid filename.
        if (index>10000) ok=true;
      }
      while (!ok);

      // Panic button - comment out if you know what you're doing
      if (index> 10000) {
        println("getIncrementalFilename thinks there is a problem - "+
          "Is there  more than 10000 files already in the sequence "+
          " or is the filename invalid?");
        println("Returning "+prefix+"ERR"+suffix);
        return prefix+"ERR"+suffix;
      }
    }

    return s;
  }
}

  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "SimpleGUI" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
