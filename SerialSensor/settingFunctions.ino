void getSerialSettings() {
  boolean haveSettings = false;
  //main loop for grabbing settings 
  // send data only when you receive data:
  while (haveSettings == false){
    Serial.println("Enter an option:");
    Serial.println("1 for a counted run");
    Serial.println("2 for a timed run");
    while (PingM<=0) {
      PingM = readEntry();
    }
    Serial.print("The PingM is ");
    Serial.println(PingM);
    if (PingM == 1) {
      //counted run
      Serial.println("You chose a counted run.");
      Serial.println("How many sensor readings should be taken?");
      while (PingC<=0) {
        PingC = readEntry();
      }
      Serial.print("The PingC is ");
      Serial.println(PingC);
      Serial.println("How many milliseconds should FredBot wait between readings?");
      while (PingD<=0) {
        PingD = readEntry();
      }
      Serial.print("The PingD is ");
      Serial.println(PingD);
      haveSettings = true;
    } 
    else if (PingM ==2) {
      //timed run
      Serial.println("You chose a timed run.");
      Serial.println("How many seconds should the run last?");
      while (runTime<=0) {
        runTime = readEntry()*1000000L;
      }
      Serial.print("The runTime is ");
      Serial.println(runTime);
      Serial.println("How many milliseconds should FredBot wait between readings?");
      while (PingD<=0) {
        PingD = readEntry();
      }
      Serial.print("The PingD is ");
      Serial.println(PingD);
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









