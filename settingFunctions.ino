void getSetting()
{
  mySettings = SD.open("settings.txt");
  countSettings();
  Serial.print("Counted ");
  Serial.println(count);
  Serial.println(freeRam());
  //These settings are for the settings loader
  String settingstring;
  //String pair;
  //String setting;
  //String value;
  boolean haveSetting = false;
  while(mySettings.available()) {
    char character = mySettings.read();
    if(character == '/') {
      while(mySettings.available()){
        character = mySettings.read();
        if(character == '\n') {
          break;
        };
      };
    } 
    else {
      settingstring.concat(character);
    };
  };  
  // close the file:
  mySettings.close();
  Serial.println(settingstring);
  Serial.println(freeRam());
  String settings[count];
  String values[count];
  int thisLineIndex = 0;
  int nextLineIndex = settingstring.indexOf('\n');
  int counter = count;
  int i = 0;
  while(counter > 0){
    Serial.println(freeRam());
    if(!settingstring){
      Serial.println("Settings not found");
      return;
    };
    Serial.println(thisLineIndex);
    Serial.println(nextLineIndex);
    String pair=settingstring.substring(thisLineIndex, nextLineIndex);
    int nextnextlineIndex= settingstring.indexOf('\n', nextLineIndex+1);
    pair.trim();
    Serial.println(pair);
    thisLineIndex = nextLineIndex;
    nextLineIndex = nextnextlineIndex;
    Serial.println(thisLineIndex);
    Serial.println(nextLineIndex);
    int eqIndex=pair.indexOf('=');
    Serial.println(eqIndex);
    // comment check
    if(pair.startsWith("/")) {
      //Serial.println("Ignoring comment");
    }
    else if((eqIndex==0) || (eqIndex==-1)) {
      Serial.println("Settings format error, skipping");
    } 
    else if((0<eqIndex) && (eqIndex<pair.length())){
      Serial.println("Setting pair loaded ok");
      int valueIndex=pair.indexOf("=");
      String setting=pair.substring(0, valueIndex-1);
      setting.trim();
      String value=pair.substring(valueIndex+1);
      value.trim();
      settings[i]=setting;
      values[i]=value;
      pair = " ";
      setting = " ";
      value = " ";
      Serial.print("Found setting: ");
      Serial.print(i); 
      Serial.print(" : ");
      Serial.print(settings[i]);
      Serial.print(" : ");
      Serial.println(values[i]);
      //haveSetting = true;
      if(settings[i].startsWith("PingC")) {
        PingCount = values[i].toInt();
      } 
      else if(settings[i].startsWith("PingD")) {
        PingDelay = values[i].toInt();
      } 
      else if(settings[i].startsWith("PingM")) {
        PingMode = values[i].toInt();
      } 
      else if(settings[i].startsWith("Time")) {
        //note: with time as an int the max magnitude value is 32,768
        //an if loop measuring the length of String values[i] combined with 
        //a new long and two toInt calls should allow all values up to 
        //the long memory limit (32 bits)
        RunTime = values[i].toInt();
      } 
      else if(settings[i].startsWith("AccelM")) {
        AccelMode = values[i].toInt();
      } 
      else if(settings[i].startsWith("DataM")) {
        DataMode = values[i].toInt();
      } 
      else if(settings[i].startsWith("loops")) {
        loops = values[i].toInt();
      };
      i++;
    } 
    else {
      Serial.println("Other error encountered, skipping line");
      count = count -1;
    };
    counter = counter - 1;
  }
  if(nextLineIndex == -1) {
    Serial.print("Found ");
    Serial.print(count);
    Serial.print(" settings on ");
    Serial.print(linecount);
    Serial.println(" lines.");
    settingstring=" ";
    return;
  };
}

void countSettings()
{
  mySettings.seek(0);
  char character; 
  //read from the file and count "=", save result to count
  while(mySettings.position() < mySettings.size()){
    character = mySettings.read();
    if(character == '/') {
      while((character != '\n') && (mySettings.available())){
        character = mySettings.read();
      };
    } 
    else if(character == '='){// set "operator"- count as setting
      //Serial.println("counting setting");
      count++;
    } 
    else if (character == '\n'){ //newline- count it
      linecount++;  
    };
  };
  mySettings.seek(0);
}












