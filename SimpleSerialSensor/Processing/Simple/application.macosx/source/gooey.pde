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

