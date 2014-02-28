void feelstuff()
{
  myData.println();  
  myData.print("i, ax, ay, az");    
  myData.println(); 
  for (int i=0; i<500; i++) {
    //Reading 6 bytes of data starting at register DATAX0 will retrieve the x,y and z acceleration values from the ADXL345.
    //The results of the read operation will get stored to the values[] buffer.
    readRegister(DATAX0, 6, values);

    //The ADXL345 gives 10-bit acceleration values, but they are stored as bytes (8-bits). To get the full value, two bytes must be combined for each axis.
    //The X value is stored in values[0] and values[1].
    x = ((int)values[1]<<8)|(int)values[0];
    //The Y value is stored in values[2] and values[3].
    y = ((int)values[3]<<8)|(int)values[2];
    //The Z value is stored in values[4] and values[5].
    z = ((int)values[5]<<8)|(int)values[4];

    //Print the results to the SD card.
    myData.print(i);
    myData.print(",");
    myData.print(x, DEC);
    myData.print(',');
    myData.print(y, DEC);
    myData.print(',');
    myData.println(z, DEC);      
    delay(10); 
  }
  Serial.println("acceleration data recorded");      
}

/*pingstuff loop has three main parameters;
run type: either a certain number of readings or a duration
run parameter: an integer, either a number of readings or seconds
delay time: a delay is hard-coded between readings
*/
void pingstuff()
{
  myData.println();  
  myData.print("i, µs, mm");
  myData.println();  

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
    myData.print(i);
    myData.print(", ");
    myData.print(time);
    myData.print(", ");
    //   myData.print(inches);
    //   myData.print("in, ");
    //   myData.print(cm);
    //   myData.print(", ");
    myData.print(mm);
    myData.println();  
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

//This function will write a value to a register on the ADXL345.
//Parameters:
//  char registerAddress - The register to write a value to
//  char value - The value to be written to the specified register.
void writeRegister(char registerAddress, char value){
  //Set Chip Select pin low to signal the beginning of an SPI packet.
  digitalWrite(chipSelectAC, LOW);
  //Transfer the register address over SPI.
  SPI.transfer(registerAddress);
  //Transfer the desired register value over SPI.
  SPI.transfer(value);
  //Set the Chip Select pin high to signal the end of an SPI packet.
  digitalWrite(chipSelectAC, HIGH);
}

//This function will read a certain number of registers starting from a specified address and store their values in a buffer.
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
  digitalWrite(chipSelectAC, LOW);
  //Transfer the starting register address that needs to be read.
  SPI.transfer(address);
  //Continue to read registers until we've read the number specified, storing the results to the input buffer.
  for(int i=0; i<numBytes; i++){
    values[i] = SPI.transfer(0x00);
  }
  //Set the Chips Select pin high to end the SPI packet.
  digitalWrite(chipSelectAC, HIGH);
}
