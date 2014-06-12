//this version of the FredBot program is dedicated to the Ping))) ultrasonic rangefinder
//parameters are blah blah and blah

#include <SD.h>

unsigned long time;
File myFile;
// this constant won't change.  It's the pin number
// of the distance sensor's output:
const int pingPin = 7;
// these two are for the alternate sensor 
// which is much cheaper than Ping)))
const int trigPin = 7;
const int echoPin = 8;
File mySettings;
const int chipSelectSD = 9;//usually 10 
unsigned int PingM;
unsigned int PingC;
unsigned int PingD;
unsigned int RunTime;
unsigned int FBLoops;
int DataM;

void setup() {
  Serial.begin(9600);
  while (!Serial) {
    ; // wait for serial port to connect. Needed for Leonardo only
  }
  Serial.println("Starting...");
  pinMode(10, OUTPUT);
  if (!SD.begin(chipSelectSD)) {
    Serial.println("SD initialization failed! Loading defaults...");
    DataM = 0;
    PingM = 0;
    PingC = 100;
    PingD = 1;
    RunTime = 0;
    FBLoops = 1;
    //return;
  } else {
  getSettings();
  }
  Serial.println("Settings imported successfully!");
  Serial.println();
  //collect data based on settings parameters
  //now we move onto doing stuff with our fresh settings
  //to start, use DataM to determine how we want to handle data
  switch (DataM) {
  case -1:
    //do nothing!
    Serial.println("Doing nothing");
    break;
  case 0:
    //print sensor readings to serial, throw them away
    pingstuff(PingC, PingD, 0);  
    break;
  case 1:
    //read ping based on parameters, print readings to serial and save
    myFile = SD.open("data.txt", FILE_WRITE);
    // if the file opened okay, jump to main loop and write to it:
    if (myFile) {
      //do stuff!
      pingstuff(PingC, PingD, 1);
      myFile.close(); 
    } 
    else {
      // if the file didn't open, print an error:
      Serial.println("error opening data.txt");
    }
    break;
  case 2:
    //read accel based on parameters, print readings and save
    break;
  case 3:
    //read both sensors continously, printing output
    break;
  case 4:
    //read sensors based on parameters, print readings and save
    break;
  }
}

void loop()
{
}
