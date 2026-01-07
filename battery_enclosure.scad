// PKCELL LP503562 3.7V 1200mAh battery + Lipo Amigo Charging Module

// Dimensions 
bat_height = 4.76;
bat_width = 34.44;
bat_length = 60.66;
bat_width_wires = 38; // width of the battery with some clearance for the wires on the side

chg_height_bat = 6.84;
chg_height_usb = 4.57;
chg_height_board = 1.22;
chg_length = 25;
chg_width = 21.04;

module battery_enclosure(
  wall_thickness = 2,
  base_thickness = 5,
  clearance = 0.5,
) {

  enclosure_length = bat_length + (2*clearance) + (2*wall_thickness)
  enclosure_width = bat_width_wires + (2*clearance) + (2*wall_thickness)
  enclosure_height = bat_height + chg_height_bat + 

  /*
  union() {

    difference() {
      cube([enclosure_length, enclosure_width,
    }

  }
  */

}
