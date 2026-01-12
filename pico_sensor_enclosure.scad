// Pico W + Sensor Enclosure Module

use <support.scad>
use <pico_sensor_lid.scad>
include <pico_sensor_dims.scad>


// Main enclosure module - fully parameterized and relocatable
module pico_sensor_enclosure(
    // Enclosure parameters
    wall_thickness = def_wall_thickness,
    clearance = def_clearance,
    base_thickness = def_base_thickness,
    
    // Post parameters
    post_diameter = def_pico_post_diameter,
    post_height = 2,
    
    
    // Features
    corner_riser_width = 2,

    // Screw Insert Spec
    screw_insert_diameter = 4.5,
    screw_insert_depth = 4,
    screw_tab_edge_offset = 2,

    // Screw Specs
    screw_threading_diameter = 2.1,
    screw_head_width = 5.2,
    screw_head_height = 1.57,
    screw_tab_height = 3,
    
    // Debug
    show_components = false
) {

    // Calculate derived dimensions
    pico_cavity_z = f_pico_cavity_z(base_thickness);
    
    enc_dims = pico_sensor_enclosure_dims(wall_thickness, clearance, base_thickness);
    
    // Calculate relative positions (from enclosure origin)
    pico_loc = pico_location(wall_thickness, clearance, base_thickness);
    pico_x = pico_loc[0];
    pico_y = pico_loc[1];
    pico_z = pico_loc[2];
    
    ada_cavity_depth = ada_height + ada_vert_clearance;
    ada_cavity_x = enc_dims[0] - ada_length_enclosed + clearance;
    ada_cavity_y = enc_dims[1]/2 - ada_width/2 - clearance;
    ada_cavity_z = pico_cavity_z - ada_cavity_depth;

    screw_insert_bezel = 3.5;
    screw_insert_tab_width = screw_insert_diameter + screw_insert_bezel;

    union() {
        // Main enclosure box
        difference() {
            // Outer shell
            cube(enc_dims);
            
            // Main inner cavity for Pico
            translate([wall_thickness, wall_thickness, pico_cavity_z])
                cube([pico_length + (2 * clearance), 
                      pico_width + (2 * clearance), 
                      pico_cavity_height + 1]);
            
            // USB cable opening
            translate([-1, enc_dims[1]/2 - 6, pico_cavity_z + pico_base_clearance])
                cube([wall_thickness + 2, 12, 6]);
            
            // Sensor back end opening
            translate([pico_length + wall_thickness, 
                       enc_dims[1]/2 - ada_width/2 - clearance, 
                       pico_cavity_z])
                cube([wall_thickness + ada_hole_offset_l_sens + wall_thickness, 
                      ada_width + clearance*2, 
                      pico_cavity_height + 1]);
            
            // Sensor cavity
            translate([ada_cavity_x, ada_cavity_y, ada_cavity_z])
                cube([ada_length_enclosed + 1, 
                      ada_width + clearance*2, 
                      ada_cavity_depth + clearance]);
            // Sensor conn cavity
            translate([ps_wiring_hole_x + ps_wiring_hole_length - boop,
                       enc_dims[1]/2 - ada_conn_width/2 - clearance,
                       base_thickness])
                cube([ada_cavity_x - (ps_wiring_hole_x + ps_wiring_hole_length) + (2*boop),
                      ada_conn_width + (2*clearance),
                      pico_cavity_z - base_thickness + boop]);

            // wiring hole
            translate([ps_wiring_hole_x,
                       enc_dims[1]/2 - ps_wiring_hole_width/2,
                       -boop])
                cube([ps_wiring_hole_length, ps_wiring_hole_width,
                      pico_cavity_z + (2*boop)]);
        }
        
        // Pico mounting posts (relative to pico position)
        // Left post
        translate([pico_x + pico_hole_offset_chg, 
                   pico_y + pico_hole_offset_w, 
                   pico_cavity_z])
            post_with_riser(post_height, post_diameter, pico_base_clearance);
        
        // Right post
        translate([pico_x + pico_hole_offset_chg, 
                   pico_y + pico_width - pico_hole_offset_w, 
                   pico_cavity_z])
            post_with_riser(post_height, post_diameter, pico_base_clearance);
        
        // Sensor mounting posts (relative to sensor cavity)
        // Left sensor post
        translate([ada_cavity_x + ada_hole_offset_l_chg,
                   ada_cavity_y + ada_width/2 + clearance - ada_width/2 + ada_hole_offset_w,
                   ada_cavity_z])
            mounting_post_assembly(post_height, ada_hole_diameter - 0.8);
        
        // Right sensor post
        translate([ada_cavity_x + ada_hole_offset_l_chg,
                   ada_cavity_y + ada_width/2 + clearance + ada_width/2 - ada_hole_offset_w,
                   ada_cavity_z])
            mounting_post_assembly(post_height, ada_hole_diameter - 0.8);
        
        // Corner risers for Pico (relative to pico area)
        translate([pico_x - clearance, pico_y - clearance, pico_cavity_z])
            corner_riser(corner_riser_width, pico_base_clearance);
        
        translate([pico_x - clearance, 
                   pico_y + pico_width - corner_riser_width + clearance, 
                   pico_cavity_z])
            corner_riser(corner_riser_width, pico_base_clearance);
        
        translate([pico_x + pico_length - corner_riser_width + clearance, 
                   pico_y - clearance, 
                   pico_cavity_z])
            corner_riser(corner_riser_width, pico_base_clearance);
        
        translate([pico_x + pico_length - corner_riser_width + clearance, 
                   pico_y + pico_width - corner_riser_width + clearance, 
                   pico_cavity_z])
            corner_riser(corner_riser_width, pico_base_clearance);

        // Screw insert tabs
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

        // Screw head tabs for connection to battery enc
        translate([enc_dims[0]/2, enc_dims[1] + screw_insert_tab_width/2, 0])
        screw_tab(
          screw_insert_tab_width, 
          screw_tab_height, 
          screw_threading_diameter,
          screw_head_height,
          screw_head_width);
        translate([enc_dims[0]/2, -screw_insert_tab_width/2, 0])
        rotate(180)
        screw_tab(
          screw_insert_tab_width, 
          screw_tab_height, 
          screw_threading_diameter,
          screw_head_height,
          screw_head_width);
    }
    
    // Debug: Show component outlines
    if (show_components) {
        // Pico board
        %translate([pico_x, pico_y, pico_z])
            cube([pico_length, pico_width, pico_thickness]);
        
        // Sensor board
        %translate([ada_cavity_x, ada_cavity_y + clearance, ada_cavity_z])
            cube([ada_length_full, ada_width, ada_height]);
    }
}



    

// Example
pico_sensor_enclosure(show_components = true);

def_dims = pico_sensor_enclosure_dims(def_wall_thickness, def_clearance, def_base_thickness);
//translate([def_dims[0]/2, - def_dims[1] - 10, 0])
//translate([def_dims[0]/2, def_dims[1]/2, def_dims[2]])
//pico_sensor_lid();
// Example: Place another one next to it
// translate([65, 0, 0])
//     pico_sensor_enclosure(show_components = false);

