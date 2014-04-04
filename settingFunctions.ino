void getSettings() {
  boolean haveSettings = false;
  //find the settings file
  mySettings = SD.open("settings.txt");
  //main loop for grabbing settings
  //look for settings until something confirms that we have them all 
  while(haveSettings == false) {
    //set pair container to empty
    String pair = " ";
    //read a character
    char character = mySettings.read();
    //get rid of it if its a comment
    if(character == '/') {
      while(character != '\n'){
        character = mySettings.read();
      };
    } 
    //make sure we're not at the end of file
    else if (character == '#') {
      haveSettings=true;
    }
    //if not a comment and not the end of file, lets try to parse it
    else {
      pair.concat(character);
      //concatenate everything into pair container
      while(character != '\n'){
        character = mySettings.read();
        pair.concat(character);
      };
      //get rid of whitespace
      pair.trim();
      //Serial.println(pair);
      //now we do the work of parsing
      //the equals sign tells us if we have a real setting=value pair
      int eqIndex=pair.indexOf('=');
      //if eqIndex comes back as 0, something is weird, and if it comes back as -1, the sign isn't even there
      //so throw it away
      if((eqIndex==0) || (eqIndex==-1)) {
        Serial.println("Settings format error, skipping");
        Serial.println(eqIndex);
        Serial.println(pair);
      } 
      //if eqIndex is between zero and the length of the pair exclusive, we have
      // something with at least one character on each side of the sign
      // so let's split it up and see if we know anything about it
      else if((0<eqIndex) && (eqIndex<pair.length())){
        //Serial.println("Setting pair loaded ok");
        String setting=pair.substring(0, eqIndex-1);
        setting.trim();
        String value=pair.substring(eqIndex+1, pair.length());
        value.trim();
        //empty pair, for safety!
        pair = " ";
        //let serial monitor know what's up
        Serial.print("Found setting: ");
        Serial.print(setting);
        Serial.print(" : ");
        Serial.println(value);
        //check if the setting=value pair is something our program can 
        // do anything with, and if so, save it
        if (setting.startsWith("PingM")) {
          PingM = value.toInt();
        } 
        else if (setting.startsWith("PingC")) {
          PingC = value.toInt();
        } 
        else if (setting.startsWith("PingD")) {
          PingD = value.toInt();
        } 
        else if (setting.startsWith("Time")) {
          RunTime = value.toInt();
        } 
        else if (setting.startsWith("FBLoops")) {
          FBLoops = value.toInt();
        } 
        else if (setting.startsWith("DataM")) {
          DataM = value.toInt();
        }
        else {
          Serial.println("Unknown setting");
        };
      }
    }
  }
  // close the file:
  mySettings.close();
}
