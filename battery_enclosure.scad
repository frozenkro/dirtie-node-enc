// PKCELL LP503562 3.7V 1200mAh battery + Lipo Amigo Charging Module

use <support.scad>

boop = 0.01;
post_height = 2;

// Dimensions 
bat_height = 4.76;
bat_width = 34.44;
bat_length = 60.66;
bat_width_wires = 38; // width of the battery with some clearance for the wires on the side

chg_height_bat = 6.84;
chg_height_usb = 4.57;
chg_height_board = 1.22;
chg_width = 25;
chg_length = 21.04;

chg_hole_offset = 2.5;
chg_hole_diameter = 2.2;

usb_opening_length = 12;

pico_enc_dims = pico_sensor_enclosure_dims();

module battery_enclosure(
  wall_thickness = 2,
  base_thickness = 2,
  clearance = 0.5,
) {
  
  enc_dims = battery_enc_dims(wall_thickness, base_thickness, clearance);
  chg_chasm_depth = chg_height_bat + 1;

  bat_z = base_thickness + chg_chasm_depth;

  inner_width = bat_width_wires + (2*clearance);

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

  }

}

function battery_enc_dims(
  wall_thickness = 2,
  base_thickness = 2,
  clearance = 0.5
) = [
  bat_length + (2*clearance) + (2*wall_thickness),
  bat_width_wires + (2*clearance) + (2*wall_thickness),
  base_thickness + bat_height + chg_height_bat + 2
];

// Example
battery_enclosure();
