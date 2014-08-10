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

