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
In general, the FredBot platform is based on modularity. So, each combination of an Arduino (or ATmega), sensing equipment, and data handling equipment will be called a module. Each module has a corresponding folder in the Manifest. All instructions for setting up that module may be found within the folder. All modules consist approximately of five steps. 

I. Program Initialization

II. Wait for input

III. Data recording run

IV. Return to II

V. Break

VI. Data handling and shutdown

===========================================
3. Manifest
===========================================

Resources/
	Papers, tutorials, and design files.

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
