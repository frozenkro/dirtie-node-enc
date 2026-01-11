// The cover panel for pico_sensor_enclosure

use <support.scad>
include <pico_sensor_dims.scad>

lid_thickness = 3;

module pico_sensor_lid(
  wall_thickness = def_wall_thickness,
  clearance = def_clearance,
  base_thickness = def_base_thickness,

  pico_post_diameter = def_pico_post_diameter,

  screw_tab_width = 8,
  screw_tab_height = 3,
  screw_tab_edge_offset = 2,

  wall_thickness = 2,

  // Screw Specs
  screw_threading_diameter = 2.1,
  screw_head_width = 5.2,
  screw_head_height = 1.57
) {

  enc_dims = pico_sensor_enclosure_dims(wall_thickness, clearance, base_thickness);
  enclosure_length = enc_dims[0];
  enclosure_width = enc_dims[1];
  enclosure_height = enc_dims[2];

  sensor_tooth_height = get_sensor_tooth_height(enclosure_height, wall_thickness, clearance);
  sensor_tooth_length = get_sensor_tooth_length(enclosure_length, wall_thickness, clearance);

  pico_loc = pico_location(wall_thickness, clearance, base_thickness);

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

    translate([enclosure_length - sensor_tooth_length,
      enclosure_width/2 - ada_width/2,
      -sensor_tooth_height])
    cube([sensor_tooth_length,
      ada_width,
      sensor_tooth_height]);
      
    translate([pico_loc[0] + pico_hole_offset_chg,
      pico_loc[1] + pico_hole_offset_w,
      -get_pico_post_socket_height(enclosure_height, base_thickness)])
    post_socket(
      get_pico_post_socket_height(enclosure_height, base_thickness), 
      pico_post_diameter);

    translate([pico_loc[0] + pico_hole_offset_chg,
      pico_loc[1] + pico_width - pico_hole_offset_w,
      -get_pico_post_socket_height(enclosure_height, base_thickness)])
    post_socket(
      get_pico_post_socket_height(enclosure_height, base_thickness), 
      pico_post_diameter);

  }

}

function get_sensor_tooth_height(
    enclosure_height,
    base_thickness,
    clearance,
) = enclosure_height - base_thickness - ada_height - clearance;

function get_sensor_tooth_length(
    enclosure_length,
    wall_thickness,
    clearance
) = enclosure_length - (wall_thickness + pico_length + (3*clearance));


function get_pico_post_socket_height(
    enclosure_height,
    base_thickness
) = enclosure_height - (get_pico_z(base_thickness)) - 2;
