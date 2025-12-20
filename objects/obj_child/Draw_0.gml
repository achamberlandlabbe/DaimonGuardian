/// obj_child Draw Event
// Draw the child (placeholder - will use actual sprite later)
draw_self();

// Draw shield indicator when child is visible on screen
var cam = view_camera[0];
var cam_x = camera_get_view_x(cam);
var cam_y = camera_get_view_y(cam);
var cam_w = camera_get_view_width(cam);
var cam_h = camera_get_view_height(cam);

// Check if child is on screen
if (point_in_rectangle(x, y, cam_x, cam_y, cam_x + cam_w, cam_y + cam_h)) {
    // Draw shield percentage bar above child
    var bar_width = 60;
    var bar_height = 6;
    var bar_x = x - bar_width/2;
    var bar_y = y - 40;
    
    // Background
    draw_set_color(c_black);
    draw_set_alpha(0.7);
    draw_rectangle(bar_x - 1, bar_y - 1, bar_x + bar_width + 1, bar_y + bar_height + 1, false);
    
    // Shield bar color based on percentage
    var shield_color;
    if (shield_percent > 50) {
        shield_color = c_aqua;  // Healthy - cyan/aqua
    } else if (shield_percent > 25) {
        shield_color = c_yellow;  // Warning - yellow
    } else {
        shield_color = c_red;  // Critical - red
    }
    
    // Fill bar
    draw_set_color(shield_color);
    draw_set_alpha(shield_alpha);
    var fill_width = (shield_percent / 100) * bar_width;
    draw_rectangle(bar_x, bar_y, bar_x + fill_width, bar_y + bar_height, false);
    
    // Shield text
    draw_set_alpha(1.0);
    draw_set_color(c_white);
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_text(x, bar_y + bar_height + 2, string(floor(shield_percent)) + "%");
    
    // Reset draw settings
    draw_set_alpha(1.0);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

// Draw shield effect around child when shield is active
if (is_invulnerable) {
    // Glowing circle effect
    draw_set_color(c_aqua);
    draw_set_alpha(0.3 * shield_alpha);
    draw_circle(x, y, 30, true);
    draw_set_alpha(0.15 * shield_alpha);
    draw_circle(x, y, 32, true);
    draw_set_alpha(1.0);
}
