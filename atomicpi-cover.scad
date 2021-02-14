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

// Heatsink
heatsink_width = 70;
heatsink_depth = 66;
heatsink_dx_from_left_inner = 17.5;
heatsink_dy_from_front_inner = 17.8;
 
// Give it 0.5cm on either side, to breathe...
heatsink_slack = 10;
heatsink_hole_width = heatsink_width + heatsink_slack;
heatsink_hole_depth = heatsink_depth + heatsink_slack;

difference() {

    // Start from a cube that will be 5.5 + 1 box_thickness high
    translate([
            -box_outer_dim_x/2,
            -box_outer_dim_y/2,
            box_outer_dim_z - box_thickness - 5.5*box_thickness])
        cube([
            box_outer_dim_x,
            box_outer_dim_y,
            6.5*box_thickness]);

    // ...and subtract the original box.
    the_box();

    // This gives us a proper cover - but wastes filament.

    // Verify dents
    // translate([0, box_outer_dim_y/2-5, box_outer_dim_z-15])
    //     cube([20,20,90]);

    // This gives us a proper cover - but wastes filament.
    // To stop wasting filament, cut a cube of box_inner_dimensions,
    // with 1 box_thickness subtracted on either side
    inner_negative_cube_x = box_inner_dim_x - 2*box_thickness;
    inner_negative_cube_y = box_inner_dim_y - 2*box_thickness;
    translate([
            -inner_negative_cube_x/2,
            -inner_negative_cube_y/2,
            0])
        cube([
            inner_negative_cube_x,
            inner_negative_cube_y,
            // Make the inside part of the cover thicker
            // This will make the closing of the box
            // a more "snag" fit.
            // It will also make the cover stronger.
            box_outer_dim_z - 3*box_thickness]);

    inner_negative_cube2_x = box_inner_dim_x - 3*box_thickness;
    inner_negative_cube2_y = box_inner_dim_y - 3*box_thickness;
    translate([
            -inner_negative_cube2_x/2,
            -inner_negative_cube2_y/2,
            0])
        cube([
            inner_negative_cube2_x,
            inner_negative_cube2_y,
            // Make the inside part of the cover thicker
            // This will make the closing of the box
            // a more "snag" fit.
            // It will also make the cover stronger.
            box_outer_dim_z - 2*box_thickness]);

    inner_negative_cube3_x = box_inner_dim_x - 4*box_thickness;
    inner_negative_cube3_y = box_inner_dim_y - 4*box_thickness;
    translate([
            -inner_negative_cube3_x/2,
            -inner_negative_cube3_y/2,
            0])
        cube([
            inner_negative_cube3_x,
            inner_negative_cube3_y,
            // Make the inside part of the cover thicker
            // This will make the closing of the box
            // a more "snag" fit.
            // It will also make the cover stronger.
            box_outer_dim_z - 1*box_thickness]);

    // Now let the heatsink "breathe".
    translate([
            -box_inner_dim_x/2 + heatsink_dx_from_left_inner
                -heatsink_slack/2,
            -box_inner_dim_y/2 + heatsink_dy_from_front_inner
                -heatsink_slack/2,
            0])
        cube([
            heatsink_hole_width,
            heatsink_hole_depth,
            // Make the inside part of the cover thicker
            // This will make the closing of the box
            // a more "snag" fit.
            // It will also make the cover stronger.
            box_outer_dim_z + 20*box_thickness]);
}

module the_box() {
    difference() {
        translate([
                -box_outer_dim_x/2,
                -box_outer_dim_y/2,
                -box_thickness])
            cube([
                box_outer_dim_x,
                box_outer_dim_y,
                box_outer_dim_z]);
    
        translate([
                -box_inner_dim_x/2,
                -box_inner_dim_y/2,
                0])
            cube([
                box_inner_dim_x,
                box_inner_dim_y,
                // Z needs the outer dim during the difference,
                // to avoid Z-fighting
                box_outer_dim_z + z_fight]);
    }
}

echo("### DBG ###", box_outer_dim_z - box_thickness - 
        (box_outer_dim_z + z_fight));
