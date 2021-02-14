// Higher definition curves
$fs = 0.1;

// on all sides
box_thickness = 1.2;

// Allow some slack to insert the board
slack = 2;

// The motherboard actual dimensions
x_board=130.2;
y_board=97.0;

// Solder and pins extruding under the power supply board
z_under_board=3;

z_fiberglass = 1.5;
z_switch = 13.2;
z_usb_adapter = 25.6;

// Diameter of power switch
switch_hole_dia=6.2;
// Offsets of power switch center
switch_hole_dx = 6;
switch_hole_dz = 6;

// Diameter of power cable
power_hole_dia = 6.0;
// Offsets of power cable center
power_hole_dx = 24.0;
power_hole_dz = 6.1 - z_fiberglass;

// Diameter of LED
led_hole_dia = 3.1;
// Offsets of LED
led_hole_dx = 15.4;
led_hole_dz = 8.8 - z_fiberglass;

// Ethernet port
eth_width=16.5;
eth_height=14.5;
eth_ofs_from_right=11.0;

// USB3 port
usb3_width=14.4;
usb3_height=7.6;

// Distance between eth and usb3
dx_usb3_eth=3.7;

// Vertical distance between USB3 and USB2 ports
dz_usb2 = 19.5 - z_fiberglass;

// Board's top surface distance from box bottom
bottom_dz=16.3;

box_outer_dim_x = x_board + 2*slack + 2*box_thickness;
box_outer_dim_y = y_board + 2*slack + 2*box_thickness;
// accommodate vertical extent of USB2.0 adapter board
// and power supply board:
//   https://www.thanassis.space/atomicpi.html
//   https://www.thanassis.space/atomicpi-usb2.html
// Also, give slack on Z-axis.
box_outer_dim_z = z_under_board + z_fiberglass + z_switch + 
    z_fiberglass + z_usb_adapter + 4*slack + 2*box_thickness;

// Inner box dimensions - just remove the 2*box_thickness
box_inner_dim_x = x_board + 2*slack;
box_inner_dim_y = y_board + 2*slack;
box_inner_dim_z = z_under_board + z_fiberglass + z_switch + 
    z_fiberglass + z_usb_adapter + 4*slack;

// Amount of shift to do to avoid z_fights
z_fight = 2.25;

// Two PCB standoffs at the back end. None at the front, since the
// front-end has the power adapter on the left (under the board)
// and a stand (cube) to support the PCB with the USB adapter board
// on the right.
standoff_dia = 2.8;
standoff_dx = 4.4;
standoff_dy = 3.7;

// Support cube at front right, underneath the USB adapter board
nut_height = 3.5;
support_cube_width = eth_width;
support_cube_height = z_under_board + z_fiberglass + z_switch - nut_height;
support_cube_depth = eth_width/2;

// HDMI
hdmi_dx_from_left = 8.8;
hdmi_width = 16;
hdmi_height=6.3;

difference() {
    // the box is made out of a cube with the boxes outer dimensions,
    // minus a cube with the inner dimensions.
    // Now, I want the box to be centered in the X/Y axis,
    // but I want it to be placed in the Z axis so that the 
    // box's inner bottom surface is at level 0.
    // Makes placement of other components much easier, 
    // since I just reference them to "ground" in Z coordinates...
    translate([-box_outer_dim_x/2, -box_outer_dim_y/2, -box_thickness])
        roundedcube([box_outer_dim_x, box_outer_dim_y, box_outer_dim_z],
             radius=1.2);

    translate([-box_inner_dim_x/2, -box_inner_dim_y/2, 0])
        cube([box_inner_dim_x, box_inner_dim_y,
                  // Z needs the outer dim during the difference,
                  // to avoid Z-fighting
                  box_inner_dim_z + z_fight],
              radius=2);

    // subtract a hole for the power switch
    translate([
        // Get to the edge of the board
        // then move backwards by our slack,
        // and then add the offset of the center of the switch
        -(box_inner_dim_x/2 - 2*slack - switch_hole_dx),
        -box_inner_dim_y/2 + z_fight,
        z_under_board + z_fiberglass + switch_hole_dz])
        rotate([90, 0, 0])
            cylinder(r=switch_hole_dia/2, h=10);

    // subtract another hole for the power cable
    translate([
        -(box_inner_dim_x/2 - 2*slack - power_hole_dx),
        -box_inner_dim_y/2 + z_fight,
        z_under_board + z_fiberglass + power_hole_dz])
        rotate([90, 0, 0])
            cylinder(r=power_hole_dia/2, h=10);

    // and remove another hole for the LED
    translate([
        -(box_inner_dim_x/2 - 2*slack - led_hole_dx),
        -box_inner_dim_y/2 + z_fight,
        z_under_board + z_fiberglass + led_hole_dz])
        rotate([90, 0, 0])
            cylinder(r=led_hole_dia/2, h=10);

    // remove the Ethernet
    translate([
        (box_inner_dim_x/2 - slack - eth_ofs_from_right),
            -box_inner_dim_y/2 + z_fight,
        z_under_board + z_fiberglass + z_switch + z_fiberglass])
        rotate([0, 0, 180])
            cube([eth_width, 10, eth_height]);

    // remove the USB3 port
    translate([
        (box_inner_dim_x/2-slack-eth_ofs_from_right-dx_usb3_eth-usb3_width),
        -box_inner_dim_y/2 + z_fight,
        z_under_board + z_fiberglass + z_switch + z_fiberglass])
        rotate([0, 0, 180])
            cube([usb3_width, 10, usb3_height]);

    // remove the USB2 port
    translate([
        (box_inner_dim_x/2-slack-eth_ofs_from_right-dx_usb3_eth-usb3_width+1),
        -box_inner_dim_y/2 + z_fight,
        z_under_board + z_fiberglass + z_switch + z_fiberglass + dz_usb2])
        rotate([0, 0, 180])
            cube([usb3_width+1, 10, usb3_height]);

    // HDMI hole
    translate([
        -(box_inner_dim_x/2 - slack - hdmi_dx_from_left),
            box_inner_dim_y/2 - z_fight,
            z_under_board + z_fiberglass + z_switch+ z_fiberglass])
        cube([hdmi_width, 10, hdmi_height]);

    // Dents for snapping the box shut
    translate([
            -(box_inner_dim_x/2 + box_thickness/2),
            -(box_inner_dim_y/2 + box_thickness/2),
            box_inner_dim_z - box_thickness/2])
        cube([
            box_inner_dim_x + box_thickness,
            box_inner_dim_y + box_thickness,
            box_thickness/2]);

    // Verify dents
    //translate([0, box_outer_dim_y/2-5, box_inner_dim_z-5])
    //    cube([10,10,10]);
    //
    //translate([0, -box_outer_dim_y/2-3, box_inner_dim_z-5])
    //    cube([10,10,10]);
    //
    //translate([box_outer_dim_x/2-5, 0,  box_inner_dim_z-5])
    //    cube([10,10,10]);
    //
    //translate([-box_outer_dim_x/2-3, 0,  box_inner_dim_z-5])
    //    cube([10,10,10]);
}

// Two PCB standoffs.
module standoff(x, y) {
    // Inside the hole
    translate([x, y, 0])
        cylinder(r=standoff_dia/2, h=23);
    // Support under
    starting_height = z_under_board;
    ending_height = z_under_board + z_fiberglass + z_switch;
    starting_dia = 3*standoff_dia/2;
    ending_dia = standoff_dia;
    for(i=[1:1:20]) {
        ratio = i/20;
        translate([x, y, 0])
            cylinder(
                r=starting_dia + ratio*(ending_dia - starting_dia),
                 h=starting_height + ratio*(ending_height - starting_height));
    }
}

standoff(
    // Get to the edge of the board
    // then move backwards by our slack,
    // and then add the offset of the center of the standoff
    -(box_inner_dim_x/2 - slack - standoff_dx),
        box_inner_dim_y/2 - standoff_dy,
        0);

standoff(
    box_inner_dim_x/2 - slack - standoff_dx,
        box_inner_dim_y/2 - standoff_dy,
        0);

// Support cube at the front-right, under the USB adapter board
translate([box_inner_dim_x/2-support_cube_width, -box_inner_dim_y/2, 0])
    cube([support_cube_width, support_cube_depth, support_cube_height]);


// Library code - reused as-is.

module roundedcube(size = [1, 1, 1], center = false, radius = 0.5, apply_to = "all") {
    // If single value, convert to [x, y, z] vector
    size = (size[0] == undef) ? [size, size, size] : size;

    translate_min = radius;
    translate_xmax = size[0] - radius;
    translate_ymax = size[1] - radius;
    translate_zmax = size[2] - radius;

    diameter = radius * 2;

    module build_point(type = "sphere", rotate = [0, 0, 0]) {
        if (type == "sphere") {
            sphere(r = radius);
        } else if (type == "cylinder") {
            rotate(a = rotate)
                cylinder(h = diameter, r = radius, center = true);
        }
    }

    obj_translate = (center == false) ?
        [0, 0, 0] : [
        -(size[0] / 2),
        -(size[1] / 2),
        -(size[2] / 2)
        ];

    translate(v = obj_translate) {
        hull() {
            for (translate_x = [translate_min, translate_xmax]) {
                x_at = (translate_x == translate_min) ? "min" : "max";
                for (translate_y = [translate_min, translate_ymax]) {
                    y_at = (translate_y == translate_min) ? "min" : "max";
                    for (translate_z = [translate_min, translate_zmax]) {
                        z_at = (translate_z == translate_min) ? "min" : "max";

                        translate(v = [translate_x, translate_y, translate_z])
                            if (
                                    (apply_to == "all") ||
                                    (apply_to == "xmin" && x_at == "min") || (apply_to == "xmax" && x_at == "max") ||
                                    (apply_to == "ymin" && y_at == "min") || (apply_to == "ymax" && y_at == "max") ||
                                    (apply_to == "zmin" && z_at == "min") || (apply_to == "zmax" && z_at == "max")
                               ) {
                                build_point("sphere");
                            } else {
                                rotate = 
                                    (apply_to == "xmin" || apply_to == "xmax" || apply_to == "x") ? [0, 90, 0] : (
                                            (apply_to == "ymin" || apply_to == "ymax" || apply_to == "y") ? [90, 90, 0] :
                                            [0, 0, 0]
                                            );
                                build_point("cylinder", rotate);
                            }
                    }
                }
            }
        }
    }
}

echo("Distance between standoffs:", 
    (box_inner_dim_x/2 - slack - standoff_dx)+
    (box_inner_dim_x/2 - slack - standoff_dx));
