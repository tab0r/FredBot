//Serial selection dropdown list made by Dumle29 (Mikkel Jeppesen) for processing, it uses the ControlP5 library and the processing.Serial library
//All other code by Tabor Henderson

import processing.serial.*;
import controlP5.*;

ControlP5 cp5;
String textValue = "";
Textarea messageArea;

Data data;  // The data file stream
DropdownList ports;              //Define the variable ports as a Dropdownlist.
Serial port;                     //Define the variable port as a Serial object.
int Ss;                          //The dropdown list will return a float value, which we will connvert into an int. we will use this int for that).
String[] comList ;               //A string to hold the ports in.
boolean serialSet;               //A value to test if we have setup the Serial port.
boolean Comselected = false;     //A value to test if you have chosen a port in the list.

String statusString;  // Status message
String fileName = "data"; // Default data log file header
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
    .setPosition(20, 145)
      .setSize(200, 100)
        .setFont(createFont("arial", 12))
          .setLineHeight(18)
            .setColor(color(128))
              .setColorBackground(color(255, 100))
                .setColorForeground(color(255, 100));
  ;
  statusString = "Select COM port above!";
  messageArea.setText(statusString);

  textFont(font);

  // List all the available serial ports:
  println(Serial.list());
  //Make a dropdown list calle ports. Lets explain the values: ("name", left margin, top margin, width, height (84 here since the boxes have a height of 20, and theres 1 px between each item so 4 items (or scroll bar).
  ports = cp5.addDropdownList("list-1", 10, 25, 200, 84)
    .setPosition(20, 140);
  //Setup the dropdownlist by using a function. This is more pratical if you have several list that needs the same settings.
  customize(ports);
}

//The dropdown list returns the data in a way, that i dont fully understand, again mokey see monkey do. However once inside the two loops, the value (a float) can be achive via the used line ;).
void controlEvent(ControlEvent theEvent) {
  if (theEvent.isGroup()) 
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
  //Set the color of the background of the items and the bar.
  ddl.setColorBackground(color(60));
  //Set the color of the item your mouse is hovering over.
  ddl.setColorActive(color(255, 128));
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
    if (inVal <= 30) {
      fill(255, 255, 0);
      xpos = inVal;
    } else if (inVal <= 700) {
      fill(0, 255, 0);
      xpos = map(inVal, 30, 700, 20, 150);
    } else {
      fill(0, 0, 255);
      xpos = map(inVal, 701, 3500, 150, 220);
    }
    //println(xpos);
    if (logging == true) {
      data.add(inVal+", "+millis());  // Write the coordinate to the file
    }
    rect(20, 360, xpos, 20);
    port.write('D');       // ask for a distance
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
      //println(inVal); //print to make sure our byte conversion is remotely sane
    }
  }
}

