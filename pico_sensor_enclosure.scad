// Pico W + Sensor Enclosure Module

// Component dimensions
pico_length = 51;
pico_width = 21;
pico_thickness = 1;
pico_hole_offset_chg = 2;
pico_hole_offset_w = 4.5;
pico_hole_diameter = 2.1;

// Adafruit sensor dimensions
ada_hole_diameter = 3.1;
ada_hole_offset_w = 2.8;
ada_hole_offset_l_chg = 23;
ada_hole_offset_l_sens = 3.175;
ada_length_enclosed = 30;
ada_length_full = 76.2;
ada_length = 101.6;
ada_height = 1.6;
ada_width = 14.3;
ada_vert_clearance = 2;

// Module for mounting post with optional support
module mounting_post_assembly(height, diameter, with_support = true, support_height = 0.5) {
    // Main post
    cylinder(h = height, d = diameter, $fn = 32);
    
    // Optional support base
    if (with_support) {
        translate([0, 0, -support_height])
            cylinder(h = support_height, d1 = diameter + 2, d2 = diameter, $fn = 32);
    }
}

// Module for a post with a riser base
module post_with_riser(post_height, post_diameter, riser_height, riser_diameter = 4) {
    // Riser
    cylinder(h = riser_height, d = riser_diameter, $fn = 32);
    
    // Post on top of riser
    translate([0, 0, riser_height - 0.5]) {
        mounting_post_assembly(post_height, post_diameter, true, 0.5);
    }
}

// Module for corner risers
module corner_riser(width, height) {
    cube([width, width, height]);
}

// Main enclosure module - fully parameterized and relocatable
module pico_sensor_enclosure(
    // Enclosure parameters
    wall_thickness = 2,
    base_thickness = 5,
    enclosure_height = 5,
    clearance = 0.25,
    
    // Post parameters
    post_diameter = 1.8,
    post_height = 2,
    
    // Pico positioning
    pico_base_clearance = 2,
    
    // Features
    corner_riser_width = 2,
    
    // Debug
    show_components = false
) {
    // Calculate derived dimensions
    enclosure_length = pico_length + ada_hole_offset_l_sens + (2 * clearance) + (2 * wall_thickness);
    enclosure_width = pico_width + (2 * clearance) + (2 * wall_thickness);
    enclosure_total_height = base_thickness + enclosure_height;
    ada_cavity_depth = ada_height + ada_vert_clearance;
    
    // Calculate relative positions (from enclosure origin)
    pico_x = wall_thickness + clearance;
    pico_y = wall_thickness + clearance;
    pico_z = base_thickness + pico_base_clearance;
    
    ada_cavity_x = enclosure_length - ada_length_enclosed + clearance;
    ada_cavity_y = enclosure_width/2 - ada_width/2 - clearance;
    ada_cavity_z = base_thickness - ada_cavity_depth;
    
    union() {
        // Main enclosure box
        difference() {
            // Outer shell
            cube([enclosure_length, enclosure_width, enclosure_total_height]);
            
            // Main inner cavity for Pico
            translate([wall_thickness, wall_thickness, base_thickness])
                cube([pico_length + (2 * clearance), 
                      pico_width + (2 * clearance), 
                      enclosure_height + 1]);
            
            // USB cable opening
            translate([-1, enclosure_width/2 - 6, base_thickness])
                cube([wall_thickness + 2, 12, 6]);
            
            // Sensor back end opening
            translate([pico_length + wall_thickness, 
                       enclosure_width/2 - ada_width/2 - clearance, 
                       base_thickness])
                cube([wall_thickness + ada_hole_offset_l_sens + wall_thickness, 
                      ada_width + clearance*2, 
                      enclosure_height + 1]);
            
            // Sensor cavity
            translate([ada_cavity_x, ada_cavity_y, ada_cavity_z])
                cube([ada_length_enclosed + 1, 
                      ada_width + clearance*2, 
                      ada_cavity_depth + clearance]);
        }
        
        // Pico mounting posts (relative to pico position)
        // Left post
        translate([pico_x + pico_hole_offset_chg, 
                   pico_y + pico_hole_offset_w, 
                   base_thickness])
            post_with_riser(post_height, post_diameter, pico_base_clearance);
        
        // Right post
        translate([pico_x + pico_hole_offset_chg, 
                   pico_y + pico_width - pico_hole_offset_w, 
                   base_thickness])
            post_with_riser(post_height, post_diameter, pico_base_clearance);
        
        // Sensor mounting posts (relative to sensor cavity)
        // Left sensor post
        translate([ada_cavity_x + ada_hole_offset_l_chg,
                   ada_cavity_y + ada_width/2 + clearance - ada_width/2 + ada_hole_offset_w,
                   ada_cavity_z])
            mounting_post_assembly(post_height, ada_hole_diameter - 0.2);
        
        // Right sensor post
        translate([ada_cavity_x + ada_hole_offset_l_chg,
                   ada_cavity_y + ada_width/2 + clearance + ada_width/2 - ada_hole_offset_w,
                   ada_cavity_z])
            mounting_post_assembly(post_height, ada_hole_diameter - 0.2);
        
        // Corner risers for Pico (relative to pico area)
        translate([pico_x - clearance, pico_y - clearance, base_thickness])
            corner_riser(corner_riser_width, pico_base_clearance);
        
        translate([pico_x - clearance, 
                   pico_y + pico_width - corner_riser_width + clearance, 
                   base_thickness])
            corner_riser(corner_riser_width, pico_base_clearance);
        
        translate([pico_x + pico_length - corner_riser_width + clearance, 
                   pico_y - clearance, 
                   base_thickness])
            corner_riser(corner_riser_width, pico_base_clearance);
        
        translate([pico_x + pico_length - corner_riser_width + clearance, 
                   pico_y + pico_width - corner_riser_width + clearance, 
                   base_thickness])
            corner_riser(corner_riser_width, pico_base_clearance);
    }
    
    // Debug: Show component outlines
    if (show_components) {
        // Pico board
        %translate([pico_x, pico_y, pico_z])
            cube([pico_length, pico_width, pico_thickness]);
        
        // Sensor board
        %translate([ada_cavity_x, ada_cavity_y + clearance, ada_cavity_z])
            cube([ada_length_full, ada_width, ada_height]);
    }
}

// Function to get enclosure dimensions (useful for positioning in larger assembly)
function pico_sensor_enclosure_dims(
    wall_thickness = 2,
    clearance = 0.5
) = [
    pico_length + ada_hole_offset_l_sens + (2 * clearance) + (2 * wall_thickness),
    pico_width + (2 * clearance) + (2 * wall_thickness),
    5 + 5  // base_thickness + enclosure_height
];

// Example usage - easy to position multiple enclosures
pico_sensor_enclosure(show_components = true);

// Example: Place another one next to it
// translate([65, 0, 0])
//     pico_sensor_enclosure(show_components = false);

// Example: Use in a larger enclosure
// translate([10, 10, 3])
//     pico_sensor_enclosure(base_thickness = 0);  // No base if sitting on another surface
