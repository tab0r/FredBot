//This version of the FredBot program is dedicated to data handling via serial communications.
//SimpleSerialSensor currently supports the ultrasonic rangefinders Ping))) and HC-SR04.
//Support for ADXL is in-progress.
//It is intended for use with nothing more than the Arduino board and sensor.
//Position your device, attach via USB, and open your serial monitor. 
//Each time you send the character 'P' to FredBot, it will return internal clock time and a ping value
//Each time you send the character 'D' it will return the ping value alone
//Add the SPI library so we can communicate with the ADXL345 sensor
#include <SPI.h>
//Assign the Chip Select signal to pin 9.
int CS=10;
//This is a list of some of the registers available on the ADXL345.
//To learn more about these and the rest of the registers on the ADXL345, read the datasheet!
char POWER_CTL = 0x2D;	//Power Control Register
char DATA_FORMAT = 0x31;
char DATAX0 = 0x32;	//X-Axis Data 0
char DATAX1 = 0x33;	//X-Axis Data 1
char DATAY0 = 0x34;	//Y-Axis Data 0
char DATAY1 = 0x35;	//Y-Axis Data 1
char DATAZ0 = 0x36;	//Z-Axis Data 0
char DATAZ1 = 0x37;	//Z-Axis Data 1

//This buffer will hold values read from the ADXL345 registers.
char values[10];
//These variables will be used to hold the x,y and z axis accelerometer values.
int x,y,z;

unsigned long time;

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
int gees[3];
char val; //input from serial

void setup() {
  //Initiate an SPI communication instance.
  SPI.begin();
  //Configure the SPI connection for the ADXL345.
  SPI.setDataMode(SPI_MODE3);
  Serial.begin(9600);
  while (!Serial) {
    ; // wait for serial port to connect. Needed for Leonardo only
  }
  establishContact();
    //Set up the Chip Select pin to be an output from the Arduino.
  pinMode(CS, OUTPUT);
  //Before communication starts, the Chip Select pin needs to be set high.
  digitalWrite(CS, HIGH);
  
  //Put the ADXL345 into +/- 4G range by writing the value 0x01 to the DATA_FORMAT register.
  //Put the ADXL345 into +/- 2G range by writing the value 0x00 to the DATA_FORMAT register.
  writeRegister(DATA_FORMAT, 0x01);
  //Put the ADXL345 into Measurement Mode by writing 0x08 to the POWER_CTL register.
  writeRegister(POWER_CTL, 0x08);  //Measurement mode 
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
    else if (val == 'D') //if we get a D for 'distance'
    {
      Serial.println(pingOnce());
    } else if (val == 'T') { // T for 'time'
      String outputTime=String(millis());
      Serial.println(outputTime);
    } else if (val == 'G') { // G for 'gees'
      feelStuff();
      Serial.print(gees[0]);
      Serial.print(", ");
      Serial.print(gees[1]);
      Serial.print(", ");
      Serial.println(gees[2]);
    } else if (val == 'K') {
      String outputTime=String(millis());
      Serial.print(outputTime);
      Serial.print(", ");
      Serial.print(pingOnce());
      Serial.print(", ");
      feelStuff();
      Serial.print(gees[0]);
      Serial.print(", ");
      Serial.print(gees[1]);
      Serial.print(", ");
      Serial.println(gees[2]);
    }
    //delay(100);
  } 
  else {
    //establishContact();
  }
}

void establishContact() {
  while (Serial.available() <= 0) {
    Serial.println("A");   // send a capital A
    delay(300);
  }
}
