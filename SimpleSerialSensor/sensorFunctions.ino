//This function reads Ping))) once and returns the reading in millimeters.
int pingOnce()
{
  float mm;
  int mmInt;
  long duration;
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
  mmInt = int(mm);
  //return mm;
  return mmInt;
}

float microsecondsToMillimeters(long microseconds)
{
  // The speed of sound is 340 m/s or 29 microseconds per centimeter.
  // The ping travels out and back, from one side of the board to the other,
  // so to find the distance of the
  // object we take half of the distance travelled, and apply the pythagorean theorem
  // return sqrt((microseconds / 2.9 / 2)+161.29);
  // using a temperature adjusted value of 347.7 m/s;
  float hyp = microseconds / 2.876 / 2;
  return sqrt((hyp*hyp)-161.29);
}


