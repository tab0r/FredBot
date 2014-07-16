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

public class Simple extends PApplet {

//Serial selection dropdown list made by Dumle29 (Mikkel Jeppesen) for processing, it uses the ControlP5 library and the processing.Serial library
//All other code by Tabor Henderson




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

public void setup() {  
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
public void controlEvent(ControlEvent theEvent) {
  if (theEvent.isGroup()) 
  {
    //Store the value of which box was selected, we will use this to acces a string (char array).
    float S = theEvent.group().value();
    //Since the list returns a float, we need to convert it to an int. For that we us the int() function.
    Ss = PApplet.parseInt(S);
    //With this code, its a one time setup, so we state that the selection of port has been done. You could modify the code to stop the serial connection and establish a new one.
    Comselected = true;
  }
}

//here we setup the dropdown list.
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
  //Set the color of the background of the items and the bar.
  ddl.setColorBackground(color(60));
  //Set the color of the item your mouse is hovering over.
  ddl.setColorActive(color(255, 128));
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
      data.add(inVal);  // Write the coordinate to the file
    }
    rect(20, 360, xpos, 20);
    port.write('D');       // ask for a distance
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

//BEGIN user input functions
public void startLog() {
  statusString = "Now logging data";
  data=new Data();
  data.beginSave();
  logging = true;
}

public void finishLog() {
  data.endSave(
  data.getIncrementalFilename(
  sketchPath("FredBot"+
    java.io.File.separator+
    fileName+
    " ####.txt")));
  statusString = "Data log saved";
  logging = false;
  //exit();  // Stops the program
}

public void fileName(String theText) {
  // automatically receives results from controller input
  println("Changing datalog name to: "+theText);
  fileName = theText;
}

//message area control
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
      if (sketchPath!=null) prefix=savePath(prefix);

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
    String[] appletArgs = new String[] { "Simple" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
