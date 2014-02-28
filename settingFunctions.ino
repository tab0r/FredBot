void getSetting()
{
  mySettings = SD.open("settings.txt");
  countSettings();
  //These settings are for the settings loader
  String settingstring = " ";
  String newsettingstring = " ";
  String pair = " ";
  String setting = " ";
  String value = " ";
  boolean haveSetting = false;
  while(mySettings.available()) {
    char character = mySettings.read();
    if(character == '/') {
      while(character != '\n'){
        character = mySettings.read();
      };
    } 
    else {
      settingstring.concat(character);
    };
  };  
  // close the file:
  mySettings.close();
  String settings[count];
  String values[count];
  int thisLineIndex = 1;
  int nextLineIndex = settingstring.indexOf('\n');
  for (int i = 0; i < count; i = i + 1){
    if(!settingstring){
      //Serial.println("Settings not found");
      return;
    };
    //Serial.println(thisLineIndex);
    //Serial.println(nextLineIndex);
    pair=settingstring.substring(thisLineIndex, nextLineIndex);
    int nextnextlineIndex= settingstring.indexOf('\n', nextLineIndex+1);
    pair.trim();
    Serial.println(pair);
    thisLineIndex = nextLineIndex;
    nextLineIndex = nextnextlineIndex;
    //Serial.println(thisLineIndex);
    //Serial.println(nextLineIndex);
    //Serial.println(newsettingstring);
    int eqIndex=pair.indexOf('=');
    //Serial.println(eqIndex);
    // comment check
    if(pair.startsWith("/")) {
      //Serial.println("Ignoring comment");
      //count=count-1;
    }
    else if((eqIndex==0) || (eqIndex==-1)) {
      //Serial.println("Settings format error, skipping");
      //count=count-1;  
    } 
    else if((0<eqIndex) && (eqIndex<pair.length())){
      //Serial.println("Setting pair loaded ok");
      int valueIndex=pair.indexOf("=");
      setting=String(pair.substring(0, valueIndex));
      setting.trim();
      value=String(pair.substring(valueIndex+1));
      value.trim();
      settings[i]=String(setting);
      values[i]=String(value);
      pair = " ";
      setting = " ";
      value = " ";
      /*Serial.print("Found setting: ");
      Serial.print(i); 
      Serial.print(" : ");
      Serial.print(settings[i]);
      Serial.print(" : ");
      Serial.println(values[i]);*/
      //haveSetting = true;
    } 
    else {
      //Serial.println("Other error encountered, skipping line");
    };
    if(settings[i].startsWith("PingCount")) {
      PingCount = values[i].toInt();
    } 
    else if(settings[i].startsWith("PingDelay")) {
      PingDelay = values[i].toInt();
    } 
    else if(settings[i].startsWith("PingMode")) {
    } 
    else if(settings[i].startsWith("Time")) {
      Time = values[i].toInt();
    } 
    else if(settings[i].startsWith("AccelMode")) {
    } 
    else if(settings[i].startsWith("DataMode")) {
    }
  }
  Serial.print("Found ");
  Serial.print(count);
  Serial.print(" settings on ");
  Serial.print(linecount);
  Serial.println(" lines.");
  settingstring=" ";
}

void countSettings()
{
  mySettings.seek(0);
  char character; 
  //read from the file and count "=", save result to count
  while(mySettings.position() < mySettings.size()){
    character = mySettings.read();
    if(character == '/') {
      while(character != '\n'){
        character = mySettings.read();
      };
    } 
    else {
    if(character == '='){// set "operator"- count as setting
      //Serial.println("counting setting");
      count++;
    } 
    else if (character == '\n'){ //newline- count it
      linecount++;  
    }; 
  };
  };
  //tack on one more to the counts to make sure we get the last line
  mySettings.seek(0);
}




