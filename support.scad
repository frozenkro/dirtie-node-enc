
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

module screw_insert_tab(insert_diameter, tab_width, tab_height) {
  translate([-(tab_width/2), -(tab_width/2), 0])
  difference() {
    union() {
      cube([tab_width, tab_width/2, tab_height]);

      translate([tab_width/2, tab_width/2, 0])
        cylinder(h = tab_height, d = tab_width, $fn = 32);
    }

    translate([tab_width/2, tab_width/2, -0.01])
      cylinder(h = tab_height + 0.02, d = insert_diameter, $fn = 32);
  }
}

screw_insert_tab(4.5, 8, 5);
