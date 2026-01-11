// The cover panel for pico_sensor_enclosure

use <support.scad>

lid_thickness = 3;

module pico_sensor_lid(
  // enclosure dimensions
  enclosure_length,
  enclosure_width,
  sensor_tooth_height,
  sensor_tooth_width,

  screw_tab_width,
  screw_tab_height,
  screw_tab_edge_offset = 2,

  wall_thickness = 2,

  // Screw Specs
  screw_threading_diameter = 2.1,
  screw_head_width = 5.2,
  screw_head_height = 1.57
) {
  translate([-enclosure_length/2, -enclosure_width/2, 0])
  union() {
    cube([enclosure_length, enclosure_width, lid_thickness]);

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
