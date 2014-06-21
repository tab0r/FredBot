//This version of the FredBot program is dedicated to data handling via serial communications.
//SimpleSerialSensor currently supports the ultrasonic rangefinders Ping))) and HC-SR04.
//Support for ADXL is in-progress.
//It is intended for use with nothing more than the Arduino board and sensor.
//Position your device, attach via USB, and open your serial monitor. 
//Each time you send the character 'P' to FredBot, it will return internal clock time and a ping value
//Each time you send the character 'D' it will return the ping value alone

long time;

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
char val; //input from serial

void setup() {
  Serial.begin(9600);
  while (!Serial) {
    ; // wait for serial port to connect. Needed for Leonardo only
  }
  establishContact();
  //Serial.println("Hello!");
}

void loop()
{
  if (Serial.available() > 0) { // If data is available to read,
    val = Serial.read(); // read it and store it in val
    if(val == 'P') //if we get a P for 'ping'
    {
      String outputTime=String(millis());
      Serial.print(outputTime);
      Serial.print(", ");
      Serial.println(pingOnce());
    }
    else if(val == 'D') //if we get a D for 'distance'
    {
      Serial.println(pingOnce());
    }
    delay(100);
  } 
  else {
  }
}

void establishContact() {
  while (Serial.available() <= 0) {
    Serial.println("A");   // send a capital A
    delay(300);
  }
}
