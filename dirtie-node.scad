// Pico W Enclosure with Mounting Posts
// All dimensions in millimeters

// Pico W dimensions
pico_length = 51;  // Actual Pico W is 51mm
pico_width = 21;
pico_thickness = 1;  // PCB thickness

// Mounting hole positions (relative to board corner)
// Pico W has 2 mounting holes at opposite corners
pico_hole_offset_chg = 2;  // Distance from edge to hole center
pico_hole_offset_w = 4.5;  // Distance from edge to hole center
pico_hole_diameter = 2.1;  // Mounting hole diameter on the Pico

// Enclosure parameters
wall_thickness = 2;
base_thickness = 5;
enclosure_height = 5;  // Internal height as requested
clearance = 0.5;  // Extra space around Pico for easy fitting

// Post parameters
post_diameter = 1.8;
post_height = 2;

// adafruit sensor dimensions
ada_hole_diameter = 3.1;
ada_hole_offset_w = 2.8;
ada_hole_offset_l_chg = 23;
ada_hole_offset_l_sens = 3.175;
ada_length_enclosed = 30;
ada_length = 101.6;
ada_height = 1.6;
ada_width = 14.3;
ada_vert_clearance = 2;

// Calculate enclosure dimensions
enclosure_length = pico_length + ada_hole_offset_l_sens + (2 * clearance) + (2 * wall_thickness);
enclosure_width = pico_width + (2 * clearance) + (2 * wall_thickness);
enclosure_total_height = base_thickness + enclosure_height;

ada_cavity_depth = ada_height + ada_vert_clearance;

pico_base_clearance = 2;
pico_height = base_thickness + pico_base_clearance;

corner_riser_width = 2;

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
            cube([wall_thickness + 2, 12, 6]);

        // Sensor back end opening
        translate([pico_length + wall_thickness, (enclosure_width/2) - (ada_width/2) - clearance, base_thickness])
            cube([wall_thickness + ada_hole_offset_l_sens + wall_thickness, ada_width + clearance*2, enclosure_height + 1]);

        // Sensor cavity
        translate([enclosure_length - ada_length_enclosed + clearance, enclosure_width/2 - ada_width/2 - clearance, base_thickness - ada_cavity_depth])
            cube([ada_length_enclosed + 1, ada_width + clearance*2, ada_cavity_depth + clearance]);
    }
}

module mounting_post(height, diameter) {
    cylinder(h = post_height, d = post_diameter, $fn = 32);
}

// Optional: Support base for posts (makes them stronger)
module post_support(diameter) {
    cylinder(h = 0.5, d1 = 4, d2 = post_diameter, $fn = 32);
}

module post_support_riser(height) {
    cylinder(h = height, d = 4, $fn = 32);
}

module corner_riser(height) {
    cube([corner_riser_width, corner_riser_width, height]);
}

// Main assembly
union() {
    // Base enclosure
    enclosure();
    
    // Mounting posts positioned at Pico W mounting holes
    // Position calculations include wall thickness and clearance
    
    // pico left post
    translate([wall_thickness + clearance + pico_hole_offset_chg, 
               wall_thickness + clearance + pico_hole_offset_w, 
               base_thickness])
            post_support_riser(pico_base_clearance - 0.5);
    translate([wall_thickness + clearance + pico_hole_offset_chg, 
               wall_thickness + clearance + pico_hole_offset_w, 
               base_thickness + pico_base_clearance - 0.5])
        union() {
            mounting_post(post_height, post_diameter);
            post_support(post_diameter);
        }
    
    // pico right post
    translate([wall_thickness + clearance + pico_hole_offset_chg, 
               wall_thickness + clearance + pico_width - pico_hole_offset_w, 
               base_thickness])
            post_support_riser(pico_base_clearance - 0.5);
    translate([wall_thickness + clearance + pico_hole_offset_chg, 
               wall_thickness + clearance + pico_width - pico_hole_offset_w, 
               base_thickness + pico_base_clearance - 0.5])
        union() {
            mounting_post(post_height, post_diameter);
            post_support(post_diameter);
        }

    translate([enclosure_length - ada_length_enclosed + ada_hole_offset_l_chg + clearance,
                enclosure_width/2 - ada_width/2 + ada_hole_offset_w,
                base_thickness - ada_cavity_depth])
        union() {
            mounting_post(post_height, ada_hole_diameter - 0.2);
            post_support(ada_hole_diameter - 0.2);
        }
    translate([enclosure_length - ada_length_enclosed + ada_hole_offset_l_chg + clearance,
                enclosure_width/2 + ada_width/2 - ada_hole_offset_w,
                base_thickness - ada_cavity_depth])
        union() {
            mounting_post(post_height, ada_hole_diameter - 0.2);
            post_support(ada_hole_diameter - 0.2);
        }

    // pico risers
    translate([wall_thickness, wall_thickness, base_thickness])
        corner_riser(pico_base_clearance);
    translate([wall_thickness, enclosure_width - wall_thickness - corner_riser_width, base_thickness])
        corner_riser(pico_base_clearance);
    translate([wall_thickness + pico_length - (2*clearance), wall_thickness, base_thickness])
        corner_riser(pico_base_clearance);
    translate([wall_thickness + pico_length - (2*clearance), enclosure_width - wall_thickness - corner_riser_width, base_thickness])
        corner_riser(pico_base_clearance);
}

