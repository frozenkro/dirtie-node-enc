
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
