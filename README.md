FredBot: Free Educational Robotics Platform
===========================================
Contents 
========
1. Mission Statement

2. Generic Program Structure

3. Manifest

4. Authorship

===========================================
1. Mission Statement:
===========================================
The FredBot Project seeks to provide resources for physical measurement and data analysis based on Arduino and other open source platforms. All resources are intended to be simple enough for 10-14 year olds to deploy at home, while being sophisticated enough to find a place in university physics labs. 

===========================================
2. Generic Program Structure
===========================================
Currently, the main goal of this project is developing a stable and highly flexible desktop-based data logging system. Originally, the FredBot platform pursued modularity. So, in the test code folder, you'll find modules designed for various use cases of FredBot. Each is a combination of an Arduino (or ATmega), sensing equipment, and data handling equipment. All modules consist approximately of five steps. 

I. Program Initialization

II. Wait for input

III. Data recording run

IV. Return to II

V. Break

VI. Data handling and shutdown

So, the current system which arises from SimpleGUI and SimpleSerialSensor is distinct only in that data is saved at III, and no VI is required. 

===========================================
3. Manifest
===========================================

Resources/
	Papers, tutorials, and design files.

SensorClass/
	A class for creating abstract sensor objects, with a test sketch.
	
SimpleGUI/
	Processing sketch to provide a GUI for the program below. 
	
SimpleSerialSensor/
	Arduino sketch which reports various sensor values in response to trigger codes.

test code/
	ADXL345_Basic/
		Stock test code for ADXL345 accelerometer
	SDSensor/
		SD card data and setting storage.
	SerialSensor/
		Data transmitted over serial, at time of run.
		Future version to include temporary storage on internal memory.
	SimpleSensor/
		Test, use at your own risk. Should be simpler, to even deserve the name.

README.md

LICENSE

===========================================
4. Authorship and License
===========================================
This project is and is based on open source information. FredBot is released on the GPL. All are welcome to contribute.

Authors:
0. Tabor C. Henderson
