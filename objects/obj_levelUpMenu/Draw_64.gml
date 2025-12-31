/// obj_levelUpMenu Draw GUI Event

// Get GUI dimensions
var gui_w = display_get_gui_width();
var gui_h = display_get_gui_height();

// Menu dimensions
var menu_width = 600;
var menu_height = 400;
var menu_x = (gui_w / 2) - (menu_width / 2);
var menu_y = (gui_h / 2) - (menu_height / 2);

// Draw semi-transparent background
draw_set_alpha(0.9);
draw_set_color(c_black);
draw_rectangle(menu_x, menu_y, menu_x + menu_width, menu_y + menu_height, false);
draw_set_alpha(1);

// Draw menu border
draw_set_color(c_white);
draw_rectangle(menu_x, menu_y, menu_x + menu_width, menu_y + menu_height, true);

// Draw title
draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_set_color(c_yellow);
draw_text(menu_x + menu_width / 2, menu_y + 20, "LEVEL UP!");

// Draw instruction text
draw_set_color(c_white);
draw_text(menu_x + menu_width / 2, menu_y + 60, "Select an Upgrade");

// Draw three upgrade buttons in a row
var upgrade_button_width = 150;
var upgrade_button_height = 80;
var upgrade_button_y = menu_y + 120;

// Calculate spacing to distribute buttons evenly
var total_button_width = upgrade_button_width * 3;
var available_space = menu_width - total_button_width;
var spacing = available_space / 4;

// Button positions
var button1_x = menu_x + spacing;
var button2_x = menu_x + spacing + upgrade_button_width + spacing;
var button3_x = menu_x + spacing + (upgrade_button_width + spacing) * 2;

// Get cursor position for hover detection
var cursor = instance_find(obj_cursor, 0);
var cursor_gui_x = 0;
var cursor_gui_y = 0;

if (cursor != noone) {
    var cam = view_camera[0];
    var cam_x = camera_get_view_x(cam);
    var cam_y = camera_get_view_y(cam);
    var cam_w = camera_get_view_width(cam);
    var cam_h = camera_get_view_height(cam);
    
    cursor_gui_x = ((cursor.x - cam_x) / cam_w) * gui_w;
    cursor_gui_y = ((cursor.y - cam_y) / cam_h) * gui_h;
}

// Draw upgrade button 1
var hover1 = false;
if (cursor != noone && point_in_rectangle(cursor_gui_x, cursor_gui_y, button1_x, upgrade_button_y, button1_x + upgrade_button_width, upgrade_button_y + upgrade_button_height)) {
    hover1 = true;
}

// Draw background if selected
if (selected_upgrade == 1) {
    draw_set_color(c_aqua);
    draw_rectangle(button1_x, upgrade_button_y, button1_x + upgrade_button_width, upgrade_button_y + upgrade_button_height, false);
}

// Draw border (yellow if highlighted, white otherwise)
if (highlighted_button == 1 || hover1) {
    draw_set_color(c_yellow);
} else {
    draw_set_color(c_white);
}
draw_rectangle(button1_x, upgrade_button_y, button1_x + upgrade_button_width, upgrade_button_y + upgrade_button_height, true);

// Draw text
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(c_white);
draw_text(button1_x + upgrade_button_width / 2, upgrade_button_y + upgrade_button_height / 2, "Upgrade 1");

// Draw upgrade button 2
var hover2 = false;
if (cursor != noone && point_in_rectangle(cursor_gui_x, cursor_gui_y, button2_x, upgrade_button_y, button2_x + upgrade_button_width, upgrade_button_y + upgrade_button_height)) {
    hover2 = true;
}

// Draw background if selected
if (selected_upgrade == 2) {
    draw_set_color(c_aqua);
    draw_rectangle(button2_x, upgrade_button_y, button2_x + upgrade_button_width, upgrade_button_y + upgrade_button_height, false);
}

// Draw border (yellow if highlighted, white otherwise)
if (highlighted_button == 2 || hover2) {
    draw_set_color(c_yellow);
} else {
    draw_set_color(c_white);
}
draw_rectangle(button2_x, upgrade_button_y, button2_x + upgrade_button_width, upgrade_button_y + upgrade_button_height, true);

// Draw text
draw_set_color(c_white);
draw_text(button2_x + upgrade_button_width / 2, upgrade_button_y + upgrade_button_height / 2, "Upgrade 2");

// Draw upgrade button 3
var hover3 = false;
if (cursor != noone && point_in_rectangle(cursor_gui_x, cursor_gui_y, button3_x, upgrade_button_y, button3_x + upgrade_button_width, upgrade_button_y + upgrade_button_height)) {
    hover3 = true;
}

// Draw background if selected
if (selected_upgrade == 3) {
    draw_set_color(c_aqua);
    draw_rectangle(button3_x, upgrade_button_y, button3_x + upgrade_button_width, upgrade_button_y + upgrade_button_height, false);
}

// Draw border (yellow if highlighted, white otherwise)
if (highlighted_button == 3 || hover3) {
    draw_set_color(c_yellow);
} else {
    draw_set_color(c_white);
}
draw_rectangle(button3_x, upgrade_button_y, button3_x + upgrade_button_width, upgrade_button_y + upgrade_button_height, true);

// Draw text
draw_set_color(c_white);
draw_text(button3_x + upgrade_button_width / 2, upgrade_button_y + upgrade_button_height / 2, "Upgrade 3");

// Draw "Confirm and Resume" button at bottom
var button_text = "Confirm and Resume";
var button_width = string_width(button_text) + 40;
var button_height = 50;
var button_x = menu_x + (menu_width / 2) - (button_width / 2);
var button_y = menu_y + menu_height - button_height - 20;

var is_hovering = false;
if (cursor != noone && point_in_rectangle(cursor_gui_x, cursor_gui_y, button_x, button_y, button_x + button_width, button_y + button_height)) {
    is_hovering = true;
}

// Draw border (yellow if highlighted, white otherwise)
if (highlighted_button == 4 || is_hovering) {
    draw_set_color(c_yellow);
} else {
    draw_set_color(c_white);
}
draw_rectangle(button_x, button_y, button_x + button_width, button_y + button_height, true);
draw_text(button_x + button_width / 2, button_y + button_height / 2, button_text);

// Draw error popup if needed
if (show_error_popup) {
    // Darken background
    draw_set_alpha(0.7);
    draw_set_color(c_black);
    draw_rectangle(0, 0, gui_w, gui_h, false);
    draw_set_alpha(1);
    
    // Error popup dimensions - made wider
    var popup_width = 500;
    var popup_height = 200;
    var popup_x = (gui_w / 2) - (popup_width / 2);
    var popup_y = (gui_h / 2) - (popup_height / 2);
    
    // Draw popup background
    draw_set_color(c_black);
    draw_rectangle(popup_x, popup_y, popup_x + popup_width, popup_y + popup_height, false);
    
    // Draw popup border
    draw_set_color(c_red);
    draw_rectangle(popup_x, popup_y, popup_x + popup_width, popup_y + popup_height, true);
    
    // Draw error message
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(c_white);
    draw_text(popup_x + popup_width / 2, popup_y + 60, "Please select an upgrade to continue");
    
    // Draw OK button
    var ok_button_text = "OK";
    var ok_button_width = 100;
    var ok_button_height = 40;
    var ok_button_x = popup_x + (popup_width / 2) - (ok_button_width / 2);
    var ok_button_y = popup_y + popup_height - ok_button_height - 30;
    
    // OK button always yellow (it's the only option)
    draw_set_color(c_yellow);
    draw_rectangle(ok_button_x, ok_button_y, ok_button_x + ok_button_width, ok_button_y + ok_button_height, true);
    
    // Draw OK button text
    draw_set_color(c_white);
    draw_text(ok_button_x + ok_button_width / 2, ok_button_y + ok_button_height / 2, ok_button_text);
}

// Reset draw settings
draw_set_halign(fa_left);
draw_set_valign(fa_top);