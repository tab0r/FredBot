//BEGIN user input functions
public void startLog() {
  statusString = "Now logging data";
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
  }
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

