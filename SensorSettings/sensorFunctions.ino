/*pingstuff function has three main parameters;
 run type: either a certain number of readings or a duration
 run parameter: an integer, either a number of readings or seconds
 delay time: a delay is hard-coded between readings
 */
void pingstuff(uint16_t pingCount, uint8_t pingDelay, uint8_t pingMode)
{
  for (int i=1; i<=pingCount; i++) {
    // establish variables for duration of the ping, 
    // and the distance result in inches and centimeters:
    long duration;
    float mm;

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
    mm = microsecondsToMillimeters(duration);
    time = micros();
    if (pingMode == 1) { 
      //myFile.print("i, micros, mm, cm");
      //myFile.println();
      myFile.print(i);
      myFile.print(", ");
      myFile.print(time);
      myFile.print(", ");
      myFile.print(mm);
      myFile.println(); 
    } 
    else  {//(pingMode == 0 || !pingMode) { 
      Serial.print(i);
      Serial.print(", ");
      Serial.print(time);
      Serial.print(", ");
      Serial.print(mm);
      Serial.println();
    } 
    delay(pingDelay);
  }
  Serial.println("distance data collected");
}

long microsecondsToMillimeters(long microseconds)
{
  // The speed of sound is 340 m/s or 29 microseconds per centimeter.
  // The ping travels out and back, so to find the distance of the
  // object we take half of the distance travelled.
  //return microseconds / 2.9 / 2;
  // code adopted from Galeriu et al
  return sqrt((microseconds/2/2.9)*(microseconds/2/2.9)-12.5*12.5);
}



