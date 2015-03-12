//GUI layout 

void gui() {
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
void controlEvent(ControlEvent theEvent) {
  if (theEvent.getName()=="list-1") 
  {
    //Store the value of which box was selected, we will use this to acces a string (char array).
    float S = theEvent.group().value();
    //Since the list returns a float, we need to convert it to an int. For that we us the int() function.
    Ss1 = int(S);
    //With this code, its a one time setup, so we state that the selection of port has been done. You could modify the code to stop the serial connection and establish a new one.
    Comselected1 = true;
  } else if (theEvent.getId()==11) {
    //calSign0.remove();
    //calSign0.setCaptionLabel("-");
  }
}

//here we setup the generic dropdown list.
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
  comList = port1.list();
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
  
  calibrationString = "Current calibration values:"+char(lf)+
    "Distance: "+distCal+char(lf)+
    "X-Axis xl: "+xlCals[0]+char(lf)+
    "Y-Axis xl: "+xlCals[1]+char(lf)+
    "Z-Axis xl: "+xlCals[2]+char(lf)+
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
  if (dataChoice[0] == 1.0) {
    fileHeader = fileHeader + "Host Clock[ms], ";
  };
  if (dataChoice[1] == 1.0) {
    fileHeader = fileHeader + "Ext Clock[ms], ";
  };
  if (dataChoice[2] == 1.0) {
    fileHeader = fileHeader + "Distance [mm], ";
  };
  if (dataChoice[3] == 1.0) {
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

void folderSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    selectedFolder = selection.getAbsolutePath();
    println("User selected " + selectedFolder);
    updateLogMessage();
  }
}
  
//message area control
void updateLogMessage() {
    logSetupString = "filepath: "+  
    selectedFolder+
    char(10)+
    "filename: "+
    fileName+
    " ####.txt";
  logSetupMessage.setText(logSetupString); 
}
//END user input functions

