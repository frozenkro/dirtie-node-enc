// PKCELL LP503562 3.7V 1200mAh battery + Lipo Amigo Charging Module

use <support.scad>
include <battery_dims.scad>
include <pico_sensor_dims.scad>

post_height = 2;

module battery_enclosure(
  wall_thickness = bat_def_wall_thickness,
  base_thickness = bat_def_base_thickness,
  clearance = bat_def_clearance,

  // Screw Insert Spec
  screw_insert_diameter = 4.5,
  screw_insert_depth = 4,
  screw_tab_edge_offset = 2,

  pico_sensor_length = pico_sensor_enclosure_dims()[0],
  pico_sensor_width = pico_sensor_enclosure_dims()[1]
) {
  
  enc_dims = battery_enclosure_dims(wall_thickness, base_thickness, clearance);
  chg_chasm_depth = chg_height_bat + 1;
  chg_chasm_length = chg_length + (2*clearance);

  bat_v_wiring_hole_x = pico_sensor_length - ps_wiring_hole_x - ps_wiring_hole_length;
  bat_h_wiring_hole_length = bat_v_wiring_hole_x - chg_chasm_length + (2*boop);

  ps_insert_hole_x = pico_sensor_length/2;
  ps_insert_hole_depth = screw_insert_depth + 1 + boop;
  
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
        cube([chg_chasm_length, 
          inner_width,
          chg_chasm_depth + boop]);
      translate([wall_thickness, 
      wall_thickness + (inner_width - chg_width) - 2*clearance, 
      base_thickness])
        cube([chg_chasm_length, 
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

      // wiring hole
      translate([bat_v_wiring_hole_x,
                 enc_dims[1]/2 - bat_wiring_hole_width/2,
                 -boop])
        cube([bat_wiring_hole_length, 
              bat_wiring_hole_width,
              get_wiring_hole_depth(base_thickness) + boop]);

      translate([wall_thickness + chg_chasm_length - boop,
                 enc_dims[1]/2 - bat_wiring_hole_width/2,
                 bat_z - bat_wiring_clearance_from_battery - bat_h_wiring_hole_height
                 ])
        cube([bat_h_wiring_hole_length,
              bat_wiring_hole_width,
              bat_h_wiring_hole_height]);

      // screw inserts for connecting to pico sensor enclosure
      translate([ps_insert_hole_x,
                 enc_dims[1]/2 - pico_sensor_width/2 - screw_insert_tab_width/2,
                 -boop])
        cylinder(h = ps_insert_hole_depth, d = screw_insert_diameter, $fn = 32);
      translate([ps_insert_hole_x,
                 enc_dims[1]/2 + pico_sensor_width/2 + screw_insert_tab_width/2,
                 -boop])
        cylinder(h = ps_insert_hole_depth, d = screw_insert_diameter, $fn = 32);
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
