void getSerialSettings() {
  boolean haveSettings = false;
  //main loop for grabbing settings 
  while (haveSettings == false){
    Serial.println("Would you like the calibrate the distance sensor?");
    Serial.println("Enter an option:");
    Serial.println("1 to calibrate");
    Serial.println("2 to use raw readings");
    int calChoice = -1;
    while (calChoice<=0) {
      calChoice = readEntry();
    }
    if (calChoice == 1) {
      Serial.println("First, set the scale factor. Place an object 10-50cm");
      Serial.println("from the sensor. Then, enter 1.");
      int calReady = -1;
      while (calReady<=0) {
        calReady = readEntry();
      }
      float cal1 = pingOnce();
      Serial.println("Now move the object 50mm (5cm) closer to FredBot and enter 1.");
      calReady = -1;
      while (calReady<=0) {
        calReady = readEntry();
      }
      float cal2 = pingOnce();
      secondOrderCal = (cal1-cal2)/50;
      Serial.print("The scale factor is ");
      Serial.println(secondOrderCal);
      Serial.println("Now determine the shift factor. Move the object to where you would");
      Serial.println("like FredBot to report 100mm (10cm), then enter 1.");
      calReady = -1;
      while (calReady<=0) {
        calReady = readEntry();
      }
      cal1 = pingOnce();
      firstOrderCal = 100 - cal1;
      Serial.print("The shift factor is ");
      Serial.println(firstOrderCal);
      Serial.println("Calibration complete!");
    }
    Serial.println("What data mode would you like?");
    Serial.println("Enter an option:");
    Serial.println("1 for a counted run");
    Serial.println("2 for a timed run");
    while (DataM<=0) {
      DataM = readEntry();
    }
    Serial.print("The DataM is ");
    Serial.println(DataM);
    if (DataM == 1) {
      //counted run
      Serial.println("You chose a counted run.");
      Serial.println("How many sensor readings should be taken?");
      while (DataC<=0) {
        DataC = readEntry();
      }
      Serial.print("The DataC is ");
      Serial.println(DataC);
      Serial.println("How many milliseconds should FredBot wait between readings?");
      while (DataD<=0) {
        DataD = readEntry();
      }
      Serial.print("The delay is ");
      Serial.println(DataD);
      haveSettings = true;
    } 
    else if (DataM ==2) {
      //timed run
      Serial.println("You chose a timed run.");
      Serial.println("How many seconds should the run last?");
      while (runTime<=0) {
        runTime = readEntry()*1000000L;
      }
      Serial.print("The runTime is ");
      Serial.println(runTime);
      Serial.println("How many milliseconds should FredBot wait between readings?");
      while (DataD<=0) {
        DataD = readEntry();
      }
      Serial.print("The delay is ");
      Serial.println(DataD);
      haveSettings = true;
    } 
    else {
    };
  }
}

int readEntry() {
  int gatheredBytes = -1;
  while (gatheredBytes == -1) {
    gatheredBytes = Serial.parseInt();
  }
  return gatheredBytes;
}










