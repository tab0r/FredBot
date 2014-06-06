//This version of the FredBot program is dedicated to ultrasonic rangefinders Ping))) and HC-SR04.
//It is intended for use with nothing more than the Arduino board and sensor.
//Position your device, attach via USB, and open your serial monitor. 
//You will be prompted for a few settings, PingMode, first of all. 
//PingMode is either Count or Time. Count will read the sensor a certain number of times. 
//Time will read the sensor as many times as possible within the given time frame.

long time;
// this constant won't change.  It's the pin number
// of the distance sensor's output:
const int pingPin = 7;
// these two are for the alternate sensor 
// which is much cheaper than Ping)))
const int trigPin = 7;
const int echoPin = 8;
int PingM=-1;
int PingC=-1;
int PingD=-1;
long runTime=-1;
long startTime;
float mm;

void setup() {
  Serial.begin(9600);
  while (!Serial) {
    ; // wait for serial port to connect. Needed for Leonardo only
  }
  Serial.println("Starting...");
  getSerialSettings();
  Serial.println("Settings confirmed");
  Serial.println();
}

void loop()
{
  for (int i = 0; i < 3; i++) {
    Serial.println(3-i);
    delay(1000);
  }
  Serial.println("Go!");
  //collect data based on settings parameters
  //now we move onto doing stuff with our fresh settings
  //print sensor readings to serial, throw them away
  Serial.println();  
  Serial.print("i, micros, mm");
  Serial.println();
  if (PingM == 1) {
    for (int i=1; i<=PingC; i++) {
      pingOnce();
      Serial.print(i);
      Serial.print(", ");
      Serial.print(time);
      Serial.print(", ");
      Serial.print(mm);
      Serial.println();  
      delay(PingD);
    }
  } 
  else if (PingM==2) {
    int i=1;
    startTime=micros();
    while (time < startTime+runTime) {
      time = micros();
      mm = pingOnce();
      Serial.print(i);
      Serial.print(", ");
      Serial.print(time);
      Serial.print(", ");
      Serial.print(mm);
      Serial.println();
      i++;
      delay(PingD);
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
    PingM = -1;
    PingC = -1;
    PingD = -1;
    runTime = -1;
    getSerialSettings();
  }
  else {
    Serial.println("Invalid choice");
  }
}




