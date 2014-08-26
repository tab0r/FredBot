class Sensor {
  Serial port;
  int id, rawValue;
  char trigger;
  String name, units, description;
  String[] readings;
  float[] calValues = {
    0, 1
  }; 
  // array holds calibration values
  // sensor readings will be 
  // calValues[0]+calValues[1]*rawValue
  
  // CONSTRUCTORS
  Sensor(char _trigger, Serial _port) {
    this.trigger = _trigger;
    this.port = _port;
    this.id = count;
    count++;
  }
  
  Sensor(char _trigger, Serial _port, String _units) {
    this(_trigger, _port);
    this.units = _units;
  }  
  
  // SETTERS
  void setPort(Serial port) {
    this.port = port;
  }
  
  void setName(String _name) {
    this.name = _name;
  }
  
  void setDesc(String _desc) {
    this.description = _desc;
  }

  void setCalibration(float calValue, int order) {
    this.calValues[order] = calValue;
    // "this.calValue" refers to the class scope
    // "calValue" alone refers to the method scope
  }

  void resetCalibration(int theSensor) {
    this.calValues[0] = 0;
    this.calValues[1] = 1;
  }
  
  // OTHERS
  void triggerSensor() {
    port.write(trigger);
  }

  //float[] bufferedReadSensor(int numReadings) {  }

  void parseInput(Serial p) {
    inData = trim(p.readStringUntil(lf)) + " [" + units + "]";
  }
}

