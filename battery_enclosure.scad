// PKCELL LP503562 3.7V 1200mAh battery + Lipo Amigo Charging Module

use <support.scad>
use <battery_lid.scad>
include <battery_dims.scad>

post_height = 2;

module battery_enclosure(
  wall_thickness = def_wall_thickness,
  base_thickness = def_base_thickness,
  clearance = def_clearance,

  // Screw Insert Spec
  screw_insert_diameter = 4.5,
  screw_insert_depth = 4,
  screw_tab_edge_offset = 2,
) {
  
  enc_dims = battery_enclosure_dims(wall_thickness, base_thickness, clearance);
  chg_chasm_depth = chg_height_bat + 1;
  
  screw_insert_bezel = 3.5;
  screw_insert_tab_width = screw_insert_diameter + screw_insert_bezel;

  bat_z = get_battery_z(base_thickness);

  inner_width = get_inner_width(clearance);

  union() {

    difference() {
      cube(enc_dims);
      
      // battery cavity
      translate([wall_thickness, wall_thickness, bat_z])
        cube([bat_length + (2*clearance), 
          inner_width, 
          bat_height + 1.1]);

      // charging module cavity
      translate([wall_thickness, wall_thickness, base_thickness + 1])
        cube([chg_length + 2*clearance, 
          inner_width,
          chg_chasm_depth + boop]);
      translate([wall_thickness, 
      wall_thickness + (inner_width - chg_width) - 2*clearance, 
      base_thickness])
        cube([chg_length + 2*clearance, 
          chg_width + 2*clearance,
          chg_chasm_depth + boop]);

      // usb opening
      translate([
      wall_thickness + clearance + (chg_length/2) - (usb_opening_length/2), 
      enc_dims[1] - wall_thickness - boop, 
      base_thickness])
        cube([usb_opening_length,
          wall_thickness + (2*boop),
        chg_height_usb + 1.5]);
      
    }

    // charging module posts
    translate([
      wall_thickness + clearance + chg_hole_offset,
      enc_dims[1] - wall_thickness - clearance - chg_hole_offset,
      base_thickness + .4])
    mounting_post_assembly(post_height, chg_hole_diameter - 0.4, with_support = true);
    translate([
      wall_thickness + clearance + chg_length - chg_hole_offset,
      enc_dims[1] - wall_thickness - clearance - chg_hole_offset,
      base_thickness + .4])
    mounting_post_assembly(post_height, chg_hole_diameter - 0.4, with_support = true);
    translate([
      wall_thickness + clearance + chg_hole_offset,
      enc_dims[1] - wall_thickness - clearance - chg_width + chg_hole_offset,
      base_thickness + .4])
    mounting_post_assembly(post_height, chg_hole_diameter - 0.4, with_support = true);
    translate([
      wall_thickness + clearance + chg_length - chg_hole_offset,
      enc_dims[1] - wall_thickness - clearance - chg_width + chg_hole_offset,
      base_thickness + .4])
     mounting_post_assembly(post_height, chg_hole_diameter - 0.4, with_support = true);

    // screw insert tabs
    rotate(180)
    translate([-(screw_insert_tab_width/2 + screw_tab_edge_offset), screw_insert_tab_width/2, enc_dims[2] - (screw_insert_depth + 1)])
    screw_insert_tab(screw_insert_diameter, screw_insert_tab_width, screw_insert_depth + 1);

    rotate(180)
    translate([-enc_dims[0] + screw_tab_edge_offset + screw_insert_tab_width/2, screw_insert_tab_width/2, enc_dims[2] - (screw_insert_depth + 1)])
    screw_insert_tab(screw_insert_diameter, screw_insert_tab_width, screw_insert_depth + 1);

    translate([screw_insert_tab_width/2 + screw_tab_edge_offset, enc_dims[1] + screw_insert_tab_width/2, enc_dims[2] - (screw_insert_depth + 1)])
    screw_insert_tab(screw_insert_diameter, screw_insert_tab_width, screw_insert_depth + 1);

    translate([enc_dims[0] - screw_insert_tab_width/2 - screw_tab_edge_offset, enc_dims[1] + screw_insert_tab_width/2, enc_dims[2] - (screw_insert_depth + 1)])
    screw_insert_tab(screw_insert_diameter, screw_insert_tab_width, screw_insert_depth + 1);

  }

}


// Example
battery_enclosure();

/*
enc_dims = battery_enclosure_dims();
translate([enc_dims[0]/2, enc_dims[1]/2, enc_dims[2]])
battery_lid();
*/
