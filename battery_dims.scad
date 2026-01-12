// battery and charging module dimensions
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

// Wiring hole (matching pico sensor for alignment)
bat_wiring_hole_width = 10;
bat_wiring_hole_length = 10;
bat_wiring_clearance_from_battery = 2;
bat_h_wiring_hole_height = 5;

// Battery default args
bat_def_wall_thickness = 2;
bat_def_clearance = 0.5;
bat_def_base_thickness = 2;

// boop
boop = 0.01;

// Function to get enclosure dimensions
function battery_enclosure_dims(
    wall_thickness = bat_def_wall_thickness,
    base_thickness = bat_def_base_thickness,
    clearance = bat_def_clearance
) = [
    bat_length + (2*clearance) + (2*wall_thickness),
    bat_width_wires + (2*clearance) + (2*wall_thickness),
    base_thickness + bat_height + chg_height_bat + 2
];

function get_battery_z(base_thickness = bat_def_base_thickness) = 
    base_thickness + chg_height_bat + 1;

function get_inner_width(clearance = bat_def_clearance) = 
    bat_width_wires + (2*clearance);

function get_wiring_hole_depth(base_thickness = bat_def_base_thickness) = 
    get_battery_z(base_thickness) - bat_wiring_clearance_from_battery;

