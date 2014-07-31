//ControlP5 library by Andreas Schlegel - http://www.sojamo.de/libraries/controlP5/
//Serial selection dropdown list made by Dumle29 (Mikkel Jeppesen) for processing
//saveData.pde Data utility by Marius Watz - http://workshop.evolutionzone.com
// 
//All other code by Tabor Henderson

import processing.serial.*;
import controlP5.*;

ControlP5 cp5;
String textValue = "";
Textarea messageArea;

Data data;                       // The data file stream
DropdownList ports;              //Define the variable ports as a Dropdownlist.
CheckBox sensorCheckBox;         //The sensor selection checkboxes
Serial port;                     //Define the variable port as a Serial object.
int Ss;                          //The dropdown list will return a float value, which we will connvert into an int. we will use this int for that).
String[] comList ;               //A string to hold the ports in.
boolean serialSet;               //A value to test if we have setup the Serial port.
boolean Comselected = false;     //A value to test if you have chosen a port in the list.

String statusString;             // Status message
String fileName = "data";        // Default data log file header
String selectedFolder;           // User-selected data folder
int inVal = 0;                   // Input value from serial port
String logData = "";             //String for catching all serial output
int logStartTime = 0;            // Integer log start time variable to give us cleaner logs
int msExt = 0;                   // Integer for the Arduino timestamp
int distVal = 0;                 // Input value for ping distance
float[] xlVals = {
  0, 0, 0
};                  // Input values for accelerometer 
int lf = 10;                     // ASCII linefeed
float xpos;
boolean firstContact = false;    // Whether we've heard from the microcontroller
boolean logging = false;

void setup() {  
  size(240, 400);//240
  PFont font = createFont("arial", 20);
  cp5 = new ControlP5(this);
  // File name input area
  cp5.addTextfield("fileName")
    .setPosition(20, 20)
      .setSize(155, 40)
        .setCaptionLabel("Enter data log filename")
          .setFont(font)
            .setFocus(true)
              .setColor(color(255, 0, 0))
                ;
  // Change file name button          
  cp5.addBang("setName")
    .setPosition(180, 20)
      .setSize(40, 40)
        .setCaptionLabel("OK")
          .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
            ;  
  // Refresh ports
  cp5.addBang("refreshCom")
    .setPosition(20, 120)
      .setSize(200, 20)
        .setCaptionLabel("Refresh COM Ports")
          .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
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
    .setPosition(20, 165)
      .setSize(200, 100)
        .setFont(createFont("arial", 12))
          .setLineHeight(18)
            .setColor(color(128))
              .setColorBackground(color(255, 100))
                .setColorForeground(color(255, 100));
  ;
  sensorCheckBox = cp5.addCheckBox("sensorCheckBox")
    .setPosition(20, 270)
      .setColorForeground(color(120))
        .setColorActive(color(255))
          .setColorLabel(color(255))
            .setSize(15, 15)
              .setItemsPerRow(1)
                .setSpacingColumn(30)
                  .setSpacingRow(5)
                    .addItem("CPU Clock Time", 1)
                      .addItem("Sensor Clock Time", 2)
                        .addItem("Ultrasonic Distance Sensor", 3)
                          .addItem("Accelerometer", 4)
                            ;
  statusString = "Select COM port above!";
  messageArea.setText(statusString);

  textFont(font);

  // List all the available serial ports:
  println(Serial.list());
  //Make a dropdown list calle ports. Lets explain the values: ("name", left margin, top margin, width, height (84 here since the boxes have a height of 20, and theres 1 px between each item so 4 items (or scroll bar).
  ports = cp5.addDropdownList("list-1", 10, 25, 200, 84)
    .setPosition(20, 160);
  //Setup the dropdownlist by using a function. This is more pratical if you have several list that needs the same settings.
  customize(ports);
  setupCOMport(ports);
  selectFolder("Select a folder to save data in:", "folderSelected");
}

//The dropdown list returns the data in a way, that i dont fully understand, again mokey see monkey do. However once inside the two loops, the value (a float) can be achive via the used line ;).
void controlEvent(ControlEvent theEvent) {
  if (theEvent.getName()=="list-1") 
  {
    //Store the value of which box was selected, we will use this to acces a string (char array).
    float S = theEvent.group().value();
    //Since the list returns a float, we need to convert it to an int. For that we us the int() function.
    Ss = int(S);
    //With this code, its a one time setup, so we state that the selection of port has been done. You could modify the code to stop the serial connection and establish a new one.
    Comselected = true;
  }
}

//here we setup the dropdown list.
void customize(DropdownList ddl) {
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
void setupCOMport(DropdownList ddl) {
  //Store the Serial ports in the string comList (char array).
  comList = port.list();
  //We need to know how many ports there are, to know how many items to add to the list, so we will convert it to a String object (part of a class).
  String comlist = join(comList, ",");
  //We also need how many characters there is in a single port name, we´ll store the chars here for counting later.
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
    port.write('K');       // ask for data
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
    distVal = Integer.parseInt(inputData[1].trim());
    msExt = Integer.parseInt(inputData[0].trim());
    xlVals[0] = Integer.parseInt(inputData[2].trim()) * 0.0078;
    xlVals[1] = Integer.parseInt(inputData[3].trim()) * 0.0078;
    xlVals[2] = Integer.parseInt(inputData[4].trim()) * 0.0078;
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

