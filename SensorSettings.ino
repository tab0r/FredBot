/* FredBot Sensor Datalogger by Tabor Henderson
 
 using Ping))) sensor, ADXL345 accelerometer and an SD-shield
 See additional notes below code
 
*/
#include <SD.h>
#include <ctype.h>
//Add the SPI library so we can communicate with the ADXL345 sensor
#include <SPI.h>
File mySettings;
File myData;
unsigned long time;
// this constant won't change.  It's the pin number
// of the sensor's output:
const int pingPin = 7;
// Setting for SD-card reader
// note that SD reader and ADXL require a chip select variable
const int chipSelectSD = 10;
//Assign the ADXL Chip Select signal to pin 10.
const int chipSelectAC=9;
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
/* These settings are the ones that FredBot (should) know how to use
 Mode conventions
 -1: default off
 0: off
 1: on
 2: other
 */
int linecount = 0;
int count = 0;
int PingMode = -1; // 1: use PingCount 2: use time
int PingCount = -1; // for mode 1
int PingDelay = -1; // for ALL modes- interval between readings
int Time = -1;  // for mode 2 
int AccelMode = -1; // 1: use ping settings 2: use Time 
int DataMode = -1; // for something I haven't made up yet; maybe a pre calculation or interpolation?
int loops = 0;

void setup()
{
  // Open serial communications and wait for port to open:
  Serial.begin(9600);
  while (!Serial) {
    ; // wait for serial port to connect. Needed for Leonardo only
  }
  Serial.println("Starting...");
  pinMode(10, OUTPUT);
  if (!SD.begin(chipSelectSD)) {
    Serial.println("SD initialization failed!");
    return;
  }
  getSetting();
}

void loop() {
  //get iterator value and loop that many times
  for(int i=0; i < loops; i++) {
    Serial.println("Looping! Wheee");
    // open the data file
    myData = SD.open("data.txt", FILE_WRITE);
    // if the file opened okay, jump to main loop and write to it:
    if ((myData) && (DataMode!=-1)) {
      //feelstuff();
      //pingstuff();
      myData.close(); 
    } 
    else {
      // if the file didn't open, print an error:
      Serial.println("error opening data.txt");
    }
    myData.close(); 
  }
}

/* This sketch is a gigantic hack! Using tutorial code for the most part, and on 20140217, attempting to add a settings header by JurgenG.
 
 Ping))) Sensor
 
 This sketch reads a PING))) ultrasonic rangefinder and returns the
 distance to the closest object in range. To do this, it sends a pulse
 to the sensor to initiate a reading, then listens for a pulse 
 to return.  The length of the returning pulse is proportional to 
 the distance of the object from the sensor.
 
 The circuit:
 	* +V connection of the PING))) attached to +5V
 	* GND connection of the PING))) attached to ground
 	* SIG connection of the PING))) attached to digital pin 7
 
 http://www.arduino.cc/en/Tutorial/Ping
 
 created 3 Nov 2008
 by David A. Mellis
 modified 30 Aug 2011
 by Tom Igoe
 
 This example code is in the public domain.
 
 */





