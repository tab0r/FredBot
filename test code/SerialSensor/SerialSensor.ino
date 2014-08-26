//This version of the FredBot program is dedicated to data handling via serial communications.
//SerialSensor currently supports the ultrasonic rangefinders Ping))) and HC-SR04.
//Support for ADXL is in-progress.
//It is intended for use with nothing more than the Arduino board and sensor.
//Position your device, attach via USB, and open your serial monitor. 
//You will be prompted for a few settings, DataMode, first of all. 
//DataMode is either Count or Time. Count will read the sensor a certain number of times. 
//Time will read the sensor as many times as possible within the given time frame.

//These variables will be useful with any sensor
long time;
long startTime;
long runTime=-1;
int DataM=-1;
int DataC=-1;
int DataD=-1;

//These variables are for the ultrasonic rangefinder
// this constant won't change.  It's the pin number
// of the Ping))) sensor's output:
const int pingPin = 7;
// these two are for the alternate HC-SR04 
// sensor which is much cheaper than Ping)))
const int trigPin = 7;
const int echoPin = 8;
// for holding the reading value
float mm;
// for holding the calibration vales
// firstOrderCal is added to the sensor reading
// secondOrderCal is multiplied by the sensor reading
float firstOrderCal = 0;
float secondOrderCal = 1;

void setup() {
  Serial.begin(9600);
  while (!Serial) {
    ; // wait for serial port to connect. Needed for Leonardo only
  }
  Serial.println("Hello!");
  getSerialSettings();
  Serial.println("Settings confirmed");
  Serial.println();
}

void loop()
{
  Serial.println("Enter 1 to begin run with a 3-second countdown, 2 to begin run immediately");
  int startChoice = -1;
  while (startChoice <= 0) { 
    startChoice = readEntry();
  }
  Serial.print("The startChoice is ");
  Serial.println(startChoice);
  if (startChoice == 1) {
    for (int i = 0; i < 3; i++) {
      Serial.println(3-i);
      delay(1000);
    }
    Serial.println("Go!");
  }
  else {
  }
  //collect data based on settings parameters
  //now we move onto doing stuff with our fresh settings
  //print sensor readings to serial, throw them away
  Serial.println();
  startTime=micros();  
  Serial.println("i, micros, mm");
  if (DataM == 1) {
    for (int i=1; i<=DataC; i++) {
      time = micros();
      mm = secondOrderCal*(firstOrderCal+pingOnce());
      Serial.print(i);
      Serial.print(", ");
      Serial.print(time-startTime);
      Serial.print(", ");
      Serial.print(mm);
      Serial.println();  
      delay(DataD);
    }
  } 
  else if (DataM==2) {
    int i=1;
    while (time < startTime+runTime) {
      time = micros();
      mm = secondOrderCal*(firstOrderCal+pingOnce());
      Serial.print(i);
      Serial.print(", ");
      Serial.print(time-startTime);
      Serial.print(", ");
      Serial.print(mm);
      Serial.println();
      i++;
      delay(DataD);
    }
  }
  Serial.println("Data collection complete.");
  Serial.println("Enter 1 to repeat the run, or 2 to change the settings.");
  int endChoice = -1;
  while (endChoice <= 0) { 
    endChoice = readEntry();
  }
  Serial.print("The endChoice is ");
  Serial.println(endChoice);
  if (endChoice == 1) {
    Serial.println("Repeating data collection run");
  }
  else if (endChoice == 2) {
    DataM = -1;
    DataC = -1;
    DataD = -1;
    runTime = -1;
    getSerialSettings();
  }
  else {
    Serial.println("Invalid choice, please reset");
  }
}
