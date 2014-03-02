FredBot: Free Educational Robotics Platform
===========================================
Contents
1. Mission Statement
2. Generic Program Structure
3. File Manifest
4. Troubleshooting
5. Known Bugs
6. Changelog
7. Authorship

===========================================
1. Mission Statement:
===========================================
The FredBot Project seeks to provide resources for physical measurement and data analysis based on Arduino and other open source platforms. All resources are intended to be simple enough for 10-14 year olds to deploy at home, while being sophisticated enough to find a place in university physics labs. 

===========================================
2. Generic Program Structure
===========================================
In general, the FredBot platform is based on modularity. So, each combination of an Arduino (or ATmega), sensing equipment, and data handling equipment will be called a module. Each module has a corresponding file in the File Manifest. All instructions for setting up that module may be found within the file. All modules approximately consist of five steps. 
I. Program Initialization
II. Wait for input
III. Data recording run
IV. Return to II
V. Data storage and shutdown

===========================================
3. File Manifest
===========================================
SimpleSensor.ino
README.md
LICENSE

===========================================
4. Troubleshooting
===========================================
Most current issues appear from the SPI serial interface. Carefully ensure each serial interface has its own pin, and each device is properly connected. 
20140228
The new settings loader will crash unexpectedly if the settingstring uses the remaining chip memory. So, depending on what sensor functions you use, you can use more settings if you comment unused functions.

===========================================
5. Known Bugs
===========================================
(1) Loss of settingstring() if it uses remaining program memory. 

===========================================
6. ChangeLog
===========================================
Wednesday, September 25, 2013
Project initialization on github by Tabor C. Henderson on behalf of MSU Denver Physics. Commit of SimpleSensor.ino, README.md, and LICENSE.
Friday, February 28, 2014
Updated to include a rudimentary settings loader. Also created new bugs. See below.

===========================================
7. Authorship and License
===========================================
This project is and is based on open source information. FredBot is released on the GPL. All are welcome to contribute.

Authors:
0. Tabor C. Henderson
