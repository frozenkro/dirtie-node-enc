// The cover panel for battery_enclosure

use <support.scad>
include <battery_dims.scad>

lid_thickness = 3;

module battery_lid(
  wall_thickness = def_wall_thickness,
  clearance = def_clearance,
  base_thickness = def_base_thickness,

  screw_tab_width = 8,
  screw_tab_height = 3,
  screw_tab_edge_offset = 2,

  // screw specs
  screw_threading_diameter = 2.1,
  screw_head_width = 5.2,
  screw_head_height = 1.57
) {

  enc_dims = battery_enclosure_dims(wall_thickness, base_thickness, clearance);
  enclosure_length = enc_dims[0];
  enclosure_width = enc_dims[1];
  enclosure_height = enc_dims[2];

  translate([-enclosure_length/2, -enclosure_width/2, 0])
  union() {
    cube([enclosure_length, enclosure_width, lid_thickness]);

    // corner screw tabs positioned around outside edges
    rotate(180)
    translate([-screw_tab_width/2 - screw_tab_edge_offset, 
    screw_tab_width/2, 
    0])
    screw_tab(screw_tab_width, screw_tab_height, screw_threading_diameter, screw_head_height, screw_head_width);
    
    rotate(180)
    translate([screw_tab_width/2 - enclosure_length + screw_tab_edge_offset, 
    screw_tab_width/2, 
    0])
    screw_tab(screw_tab_width, screw_tab_height, screw_threading_diameter, screw_head_height, screw_head_width);
    
    translate([screw_tab_width/2 + screw_tab_edge_offset, 
    screw_tab_width/2 + enclosure_width, 
    0])
    screw_tab(screw_tab_width, screw_tab_height, screw_threading_diameter, screw_head_height, screw_head_width);
    
    translate([-screw_tab_width/2 + enclosure_length - screw_tab_edge_offset, 
    screw_tab_width/2 + enclosure_width, 
    0])
    screw_tab(screw_tab_width, screw_tab_height, screw_threading_diameter, screw_head_height, screw_head_width);
  }
}

// example
battery_lid();
