// Component dimensions
pico_length = 51;
pico_width = 21;
pico_thickness = 1;
pico_hole_offset_chg = 2;
pico_hole_offset_w = 4.7;
pico_hole_diameter = 2.1;
pico_cavity_height = 7.5;
pico_base_clearance = 2;

// Adafruit sensor dimensions
ada_hole_diameter = 3.1;
ada_hole_offset_w = 2.8;
ada_hole_offset_l_chg = 23;
ada_hole_offset_l_sens = 3.175;
ada_length_enclosed = 30;
ada_length_full = 76.2;
ada_length = 101.6;
ada_height = 1.5;
ada_width = 14.3;
ada_vert_clearance = 1.5;

// default args
def_wall_thickness = 2;
def_clearance = 0.25;
def_base_thickness = 1;
def_pico_post_diameter = 1.6;


// Function to get enclosure dimensions (useful for positioning in larger assembly)
function pico_sensor_enclosure_dims(
    wall_thickness = 2,
    clearance = 0.5,
    base_thickness = 1
) = [
    pico_length + ada_hole_offset_l_sens + (2 * clearance) + (2 * wall_thickness),
    pico_width + (2 * clearance) + (2 * wall_thickness),
    f_pico_cavity_z(base_thickness) + pico_cavity_height
];

function f_pico_cavity_z(
  base_thickness = 1
) = base_thickness + ada_height + ada_vert_clearance;

function get_pico_z(
  base_thickness
) = f_pico_cavity_z(base_thickness) + pico_base_clearance;

function pico_location(
  wall_thickness,
  clearance,
  base_thickness
) = [
  wall_thickness + clearance,
  wall_thickness + clearance,
  get_pico_z(base_thickness)
];
