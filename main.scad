// dirtie-node soil sensor module enclosure

use <battery_enclosure.scad>
use <battery_lid.scad>
use <pico_sensor_enclosure.scad>
use <pico_sensor_lid.scad>

pico_sensor_dims = pico_sensor_enclosure_dims();
bat_dims = battery_enclosure_dims();

mirror([0,0,1]) {
  battery_enclosure();
}

translate([pico_sensor_dims[0], bat_dims[1]/2 - pico_sensor_dims[1]/2, 0])
mirror([1,0,0]) {
pico_sensor_enclosure();
}
