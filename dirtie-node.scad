// Pico W Enclosure with Mounting Posts
// All dimensions in millimeters

// Pico W dimensions
pico_length = 51;  // Actual Pico W is 51mm
pico_width = 21;
pico_thickness = 1;  // PCB thickness

// Mounting hole positions (relative to board corner)
// Pico W has 2 mounting holes at opposite corners
pico_hole_offset = 2;  // Distance from edge to hole center
pico_hole_diameter = 2.1;  // Mounting hole diameter on the Pico

// Enclosure parameters
wall_thickness = 2;
base_thickness = 3;
enclosure_height = 5;  // Internal height as requested
clearance = 0.5;  // Extra space around Pico for easy fitting

// Post parameters
post_diameter = 1.8;  // Smaller diameter to fit THROUGH the Pico's holes
post_height = 3;  // Height of posts from base (should be taller than PCB thickness)

// adafruit sensor dimensions (MEASURED WITH TAPE MEASURE, PROBABLY A BIT OFF)
ada_hole_diameter = 3.1;
ada_hole_offset_w = 2.8;
ada_hole_offset_l_chg = 22.25;
ada_hole_offset_l_sens = 3.175;
ada_length_enclosed = 25.4;
ada_length = 101.6;
ada_height = 1.6;
ada_width = 14.3;

// Calculate enclosure dimensions
enclosure_length = pico_length + ada_hole_offset_l_sens + (2 * clearance) + (2 * wall_thickness);
enclosure_width = pico_width + (2 * clearance) + (2 * wall_thickness);
enclosure_total_height = base_thickness + enclosure_height;

// Main enclosure module
module enclosure() {
    difference() {
        // Outer box
        cube([enclosure_length, enclosure_width, enclosure_total_height]);
        
        // Inner cavity
        translate([wall_thickness, wall_thickness, base_thickness])
            cube([pico_length + (2 * clearance), 
                  pico_width + (2 * clearance), 
                  enclosure_height + 1]);
        
        // Cable opening (for USB port)
        translate([-1, enclosure_width/2 - 6, base_thickness])
            cube([wall_thickness + 2, 12, 4]);

        // Sensor back end opening
        translate([pico_length + wall_thickness, (enclosure_width/2) - (ada_width/2) - clearance, base_thickness])
            cube([wall_thickness + ada_hole_offset_l_sens + wall_thickness, ada_width + clearance*2, enclosure_height + 1]);

        // Sensor cavity
        translate([enclosure_length - ada_length_enclosed, enclosure_width/2 - ada_width/2 - clearance, (base_thickness - ada_height) + 0.2])
            cube([ada_length_enclosed + 1, ada_width + clearance*2, ada_height + 0.5]);
    }
}

module mounting_post(height, diameter) {
    cylinder(h = post_height, d = post_diameter, $fn = 32);
}

// Optional: Support base for posts (makes them stronger)
module post_support(diameter) {
    cylinder(h = 0.5, d1 = 4, d2 = post_diameter, $fn = 32);
}

// Main assembly
union() {
    // Base enclosure
    enclosure();
    
    // Mounting posts positioned at Pico W mounting holes
    // Position calculations include wall thickness and clearance
    
    // pico left post
    translate([wall_thickness + clearance + pico_hole_offset, 
               wall_thickness + clearance + pico_hole_offset, 
               base_thickness])
        union() {
            mounting_post(post_height, post_diameter);
            post_support(post_diameter);
        }
    
    // pico right post
    translate([wall_thickness + clearance + pico_hole_offset, 
               wall_thickness + clearance + pico_width - pico_hole_offset, 
               base_thickness])
        union() {
            mounting_post(post_height, post_diameter);
            post_support(post_diameter);
        }

    translate([enclosure_length - ada_hole_offset_l_sens,
                enclosure_width/2 - ada_width/2 + ada_hole_offset_w + clearance,
                base_thickness - ada_height])
        union() {
            mounting_post(post_height, ada_hole_diameter - 0.2);
            post_support(ada_hole_diameter - 0.2);
        }
    translate([enclosure_length - ada_hole_offset_l_sens,
                enclosure_width/2 + ada_width/2 + clearance - ada_hole_offset_w,
                base_thickness - ada_height])
        union() {
            mounting_post(post_height, ada_hole_diameter - 0.2);
            post_support(ada_hole_diameter - 0.2);
        }
}

// Optional: Show Pico W outline for reference (comment out for printing)
// %translate([wall_thickness + clearance, wall_thickness + clearance, base_thickness + 1])
//     cube([pico_length, pico_width, pico_thickness]);
