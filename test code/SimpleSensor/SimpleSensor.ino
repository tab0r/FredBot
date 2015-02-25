/* SimpleSensor.ino rangefinder/accelerometer datalogger
This sketch records data from one or more sensing devices onto an SD card. 
Currently, the main loop must be edited to determine which sensor is used.
Hardware:
Arduino UNO
Seeed Studios SD shield
PING))) ultrasonic rangefinder
ADXL345 accelerometer on SparkFun breakout

Arduino Pin	ADXL345 Pin
	9	 CS
	11	 SDA
	12	 SDO
	13	 SCL
	3V3	 VCC
	Gnd	 GND
Arduino Pin	PING))) Pin
	5V	 +V
	Gnd	 GND
	7	 SIG
Arduino Pin	SD Pin
	10	 Output


pingstuff{}
  
   This loop reads a PING))) ultrasonic rangefinder and returns the
   distance to the closest object in range. To do this, it sends a pulse
   to the sensor to initiate a reading, then listens for a pulse 
   to return.  The length of the returning pulse is proportional to 
   the distance of the object from the sensor.
     
   http://www.arduino.cc/en/Tutorial/Ping
   
   created 3 Nov 2008
   by David A. Mellis
   modified 30 Aug 2011
   by Tom Igoe
 
   This code is in the public domain on GPL.

 */
#include <SD.h>
//Add the SPI library so we can communicate with the ADXL345 sensor
#include <SPI.h>

//Assign the ADXL345 Chip Select signal to pin 9. Note that this differs from the SparkFun guide.
int CS=9;

//Assign the SD output to pin 10. 
int SD=10;

unsigned long time;
File myFile;

// this constant won't change.  It's the pin number
// of the sensor's output:
const int pingPin = 7;
const int echoPin = 8;

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

void setup() {
  //Initiate an SPI communication instance.
  SPI.begin();
  //Configure the SPI connection for the ADXL345.
  SPI.setDataMode(SPI_MODE3);
  //Create a serial connection to display the data on the terminal.
  // Open serial communications and wait for port to open:
  Serial.begin(9600);
   while (!Serial) {
    ; // wait for serial port to connect. Needed for Leonardo only
  }


  Serial.print("Initializing SD card and accelerometer serial interfaces...");
  // On the Ethernet Shield, CS is pin 4. It's set as an output by default.
  // Note that even if it's not used as the CS pin, the hardware SS pin 
  // (10 on most Arduino boards, 53 on the Mega) must be left as an output 
  // or the SD library functions will not work. 
   pinMode(SD, OUTPUT);
   
  if (!SD.begin(SD)) {
    Serial.println("SD output initialization failed!");
    return;
  }
  
  //Set up the  ADXL345 Chip Select pin to be an output from the Arduino.
  pinMode(CS, OUTPUT);
  //Before communication starts, the Chip Select pin needs to be set high.
  digitalWrite(CS, HIGH);
  
  //Put the ADXL345 into +/- 4G range by writing the value 0x01 to the DATA_FORMAT register.
  writeRegister(DATA_FORMAT, 0x01);
  //Put the ADXL345 into Measurement Mode by writing 0x08 to the POWER_CTL register.
  writeRegister(POWER_CTL, 0x08);  //Measurement mode  
  Serial.println("accelerometer measurement mode initialized.");
  
  // open the file. note that only one file can be open at a time,
  // so you have to close this one before opening another.
  myFile = SD.open("data.txt", FILE_WRITE);
  
  // if the file opened okay, jump to main loop and write to it:
  if (myFile) {
    feelstuff();
    //pingstuff();
    myFile.close(); 
  } else {
    // if the file didn't open, print an error:
    Serial.println("error opening data.txt");
  }
}

void feelstuff()
{
  myFile.println();  
  myFile.print("i, ax, ay, az");    
  myFile.println(); 
for (int i=0; i<500; i++) {
  //Reading 6 bytes of data starting at register DATAX0 will retrieve 
  //the x,y and z acceleration values from the ADXL345.
  //The results of the read operation will get stored to the values[] buffer.
  readRegister(DATAX0, 6, values);

  //The ADXL345 gives 10-bit acceleration values, but they are stored as bytes (8-bits). 
  //To get the full value, two bytes must be combined for each axis.
  //The X value is stored in values[0] and values[1].
  x = ((int)values[1]<<8)|(int)values[0];
  //The Y value is stored in values[2] and values[3].
  y = ((int)values[3]<<8)|(int)values[2];
  //The Z value is stored in values[4] and values[5].
  z = ((int)values[5]<<8)|(int)values[4];
  
  //Print the results to the SD card.
  myFile.print(i);
  myFile.print(",");
  myFile.print(x, DEC);
  myFile.print(',');
  myFile.print(y, DEC);
  myFile.print(',');
  myFile.println(z, DEC);      
  delay(10); 
}
  Serial.println("acceleration data recorded");      
}
void pingstuff()
{
    myFile.println();  
    myFile.print("i, µs, mm");
    myFile.println();  

  for (int i=0; i<500; i++) {
    // establish variables for duration of the ping, 
    // and the distance result in inches and centimeters:
    long duration, inches, cm, mm;
  
    // The PING))) is triggered by a HIGH pulse of 2 or more microseconds.
    // Give a short LOW pulse beforehand to ensure a clean HIGH pulse:
    pinMode(pingPin, OUTPUT);
    digitalWrite(pingPin, LOW);
    delayMicroseconds(2);
    digitalWrite(pingPin, HIGH);
    delayMicroseconds(5);
    digitalWrite(pingPin, LOW);
  
    // The same pin is used to read the signal from the PING))): a HIGH
    // pulse whose duration is the time (in microseconds) from the sending
    // of the ping to the reception of its echo off of an object.
    pinMode(pingPin, INPUT);
    duration = pulseIn(pingPin, HIGH);
  
    // convert the time into a distance
    inches = microsecondsToInches(duration);
    cm = microsecondsToCentimeters(duration);
    mm = microsecondsToMillimeters(duration);
    time = micros();
    myFile.print(i);
    myFile.print(", ");
    myFile.print(time);
    myFile.print(", ");
 //   myFile.print(inches);
 //   myFile.print("in, ");
 //   myFile.print(cm);
 //   myFile.print(", ");
    myFile.print(mm);
    myFile.println();  
    delay(10);
  }
  Serial.println("distance data recorded");
  }

long microsecondsToInches(long microseconds)
{
  // According to Parallax's datasheet for the PING))), there are
  // 73.746 microseconds per inch (i.e. sound travels at 1130 feet per
  // second).  This gives the distance travelled by the ping, outbound
  // and return, so we divide by 2 to get the distance of the obstacle.
  // See: http://www.parallax.com/dl/docs/prod/acc/28015-PING-v1.3.pdf
  return microseconds / 74 / 2;
}

long microsecondsToCentimeters(long microseconds)
{
  // The speed of sound is 340 m/s or 29 microseconds per centimeter.
  // The ping travels out and back, so to find the distance of the
  // object we take half of the distance travelled.
  return microseconds / 29 / 2;
}

long microsecondsToMillimeters(long microseconds)
{
  // The speed of sound is 340 m/s or 29 microseconds per centimeter.
  // The ping travels out and back, so to find the distance of the
  // object we take half of the distance travelled.
  return microseconds / 2.9 / 2;
}

void loop() {}


//This function will write a value to a register on the ADXL345.
//Parameters:
//  char registerAddress - The register to write a value to
//  char value - The value to be written to the specified register.
void writeRegister(char registerAddress, char value){
  //Set Chip Select pin low to signal the beginning of an SPI packet.
  digitalWrite(CS, LOW);
  //Transfer the register address over SPI.
  SPI.transfer(registerAddress);
  //Transfer the desired register value over SPI.
  SPI.transfer(value);
  //Set the Chip Select pin high to signal the end of an SPI packet.
  digitalWrite(CS, HIGH);
}

//This function will read a certain number of registers starting from a specified
//address and store their values in a buffer.
//Parameters:
//  char registerAddress - The register addresse to start the read sequence from.
//  int numBytes - The number of registers that should be read.
//  char * values - A pointer to a buffer where the results of the operation should be stored.
void readRegister(char registerAddress, int numBytes, char * values){
  //Since we're performing a read operation, the most significant bit of the register address should be set.
  char address = 0x80 | registerAddress;
  //If we're doing a multi-byte read, bit 6 needs to be set as well.
  if(numBytes > 1)address = address | 0x40;
  
  //Set the Chip select pin low to start an SPI packet.
  digitalWrite(CS, LOW);
  //Transfer the starting register address that needs to be read.
  SPI.transfer(address);
  //Continue to read registers until we've read the number specified, storing the results to the input buffer.
  for(int i=0; i<numBytes; i++){
    values[i] = SPI.transfer(0x00);
  }
  //Set the Chips Select pin high to end the SPI packet.
  digitalWrite(CS, HIGH);
}
