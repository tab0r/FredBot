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
  
  // these static variables can be un-commented in a full Java IDE
  // static int count;
  // static int prevSensor;
  // static int prevReadingRecieved;
  
  // CONSTRUCTORS
  // basic 
  Sensor(char _trigger, Serial _port) {
    this.trigger = _trigger;
    this.port = _port;
    this.id = count;
    count++;
  }
  
  // with units
  Sensor(char _trigger, Serial _port, String _units) {
    this(_trigger, _port);
    this.units = _units;
  }  
  
  // with units & name
  Sensor(char _trigger, Serial _port, String _units, String _name) {
    this(_trigger, _port, _units);
    this.name = _name;
  } 
  
  // with units, name & description
  Sensor(char _trigger, Serial _port, String _units, String _name, String _desc) {
    this(_trigger, _port, _units, _name);
    this.description = _desc;
  }  
  
  // SETTERS
  void setPort(Serial _port) {
    this.port = _port;
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

  String parseInput() {
    return trim(port.readStringUntil(lf)) + " [" + units + "]";
  }
}

