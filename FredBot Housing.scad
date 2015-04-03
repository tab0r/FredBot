module sensorBody()
{
    	difference() {
		union() {
			// main volume	
			cube([80, 80, 25], true);
			// track mount arms
			translate([0, -37, 0]) trackArm();
		}
		// main cavity
		translate([-34, -45, 0]) cube([68, 50, 13], false);
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
module pingHousing() 
{
	intersection() {
		cube([35, 25, 82], true);
		difference() {
			union() 
			{
				cylinder(60, 15, 15, true);
				cylinder(80, 3, 3, true);
			}
			translate([0, -11, 0]) 
			{
				cube([22, 30, 50], true); //main cavity
			}
			translate([-15, -5, 0]) 
			{
				cube(15, true); //wire hole
			}
			// act. light hole
			translate([0, 8, 0]) rotate([90, 0, 0]) cylinder(17, 1.5, 1.5, true);
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


module FredBotAssumbly() 
{
	translate([0,25,0]) rotate([-90, 0, 90]) pingHousing();
	sensorBody();
}
module fingers(h) 
{
	t = 5.5;
	w = 3;
	translate([w/2,-5.65,0]) cube([t, 11, h], false);
	translate([-(0.5+t+w/2),-10,0]) cube([t, 20, h], false);
	translate([-(w+1)/2,-0.5,0]) cube([w+2, 1, h], false);
}
module trackArm() 
{	
	cube([125, 25, 10], true);
	translate([52, 0, -4]) rotate([0, 180, 0]) fingers(20);
	translate([-52, 0, -4]) rotate([180, 0, 0]) fingers(20);
}
module unibodyFredbot() {
translate([0,25,0]) rotate([-90, 0, 90]) pingHousing();
	difference() {
		union() {
			// main volume	
			translate([0, -35, 0]) cube([80, 30, 25], true);
			// track mount arms
			translate([0, -37, -7.5]) trackArm();
			// neck frame
			translate([10.25, -6.25, 0]) cube([5, 40, 10], true);
			translate([-10.25, -6.25, 0]) cube([5, 40, 10], true);
			translate([0, -8, 0]) rotate([0, 0, 25]) cube([2, 40, 2], true);
			translate([0, -8, 0]) rotate([0, 0, -25]) cube([2, 40, 2], true);
            // nametag
		    translate([-30, - 22, -6]) cube([35, 10, 2], false)
            translate([0, - 22, -12])
                rotate([0, 180, 0]) 
				linear_extrude(height = 1) { 
                           text("FredBot", size = 5, font = "Liberation Sans"); 
                        }
            // details text
            translate([0, - 26, -12]) 
                rotate([0, 180, 0]) 
                    linear_extrude(height = 1) { 
                           text("TW105-FT5.5", size = 3, font = "Liberation Sans");
                    }
            
        }
		// main cavity
		translate([0, -35, 7]) cube([68, 22, 13], true);
		// wire hole
		translate([0, -20, 8]) cube(10, true); 
		// Teensy recess
		translate([-38, -45, -5]) cube([34, 19, 6], false);
		// USB port hole
		translate([-41, -41, -2]) cube([11, 12, 5], false);
		// accelero recess
		translate([0, -45, -5]) cube([19, 19, 6], false);
	}
}

unibodyFredbot();
//difference() {trackArm();  cube([80, 18, 12], true); }