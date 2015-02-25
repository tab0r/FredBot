module pingHousing() 
{
	intersection() {
		cube([35, 25, 82], true);
		difference() {
			union() 
			{
				cylinder(60, 15, 15, true);
				cylinder(80, 5, 5, true);
			}
			translate([0, -15, 0]) 
			{
				cube([22, 30, 50], true); //main cavity
			}
			translate([-15, -9, 0]) 
			{
				cube(15, true); //wire hole
			}
			//can holes
			translate([0, 8, 13])
			{
				rotate([90, 0, 0]) cylinder(17, 9, 9, true);
			}
			translate([0, 8, -13])
			{
				rotate([90, 0, 0]) cylinder(17, 9, 9, true);
			}
		}
	}
}

module sensorBody()
{
	difference() {
		union() {
			// main volume	
			cube([80, 80, 25], true);
			// track mount arms
			translate([35, -7.5, -60+12.5]) cube([15, 15, 60], false);
			translate([-50, -7.5, -60+12.5]) cube([15, 15, 60], false);
		}
		// main cavity
		translate([-34, -33, 0]) cube([68, 35, 13], false);
		// Teensy recess
		translate([-38, -28, -5]) cube([34, 19, 6], false);
		// USB port hole
		translate([-41, -24, -5]) cube([11, 12, 10], false);
		// accelero recess
		translate([0, -28, -5]) cube([19, 19, 6], false);
		// wire clearance
		translate([0, 4, 0]) cube([15, 20, 26], true);
		//  big cylinder
		rotate([0, 90, 0]) translate([0,25,0]) cylinder(62, 17, 17, true);
		// trim off unecessary stuff that won't print well
		translate([0,40,0]) cube([62, 15, 26], true);
		// axle hole
		rotate([0, 90, 0]) translate([0,25,0]) cylinder(82, 5.25, 5.25, true);
		}
}

module FredBotAssumbly() 
{
	translate([0,25,0]) rotate([-90, 0, 90]) pingHousing();
	sensorBody();
}

FredBotAssumbly();