/// obj_skillSelectionMenu Draw GUI Event

// Get GUI dimensions
var gui_w = display_get_gui_width();
var gui_h = display_get_gui_height();

// Menu dimensions
var menu_width = 900;
var menu_height = 400; // Shorter than upgrade menu
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
draw_text(menu_x + menu_width / 2, menu_y + 20, "NEW SKILL UNLOCKED!");

// Draw instruction text
draw_set_color(c_white);
draw_text(menu_x + menu_width / 2, menu_y + 60, "Choose Your New Skill");

// Skill button dimensions
var skill_button_width = 225;
var skill_button_height = 120;
var button_y = menu_y + 100;

// Calculate spacing to distribute buttons evenly
var total_button_width = skill_button_width * 3;
var available_space = menu_width - total_button_width;
var spacing = available_space / 4;

// Button positions
var button1_x = menu_x + spacing;
var button2_x = menu_x + spacing + skill_button_width + spacing;
var button3_x = menu_x + spacing + (skill_button_width + spacing) * 2;

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

var text_y = button_y + 15;
var line_spacing = 30;

// Define skill names based on tier (placeholder - you'll replace these)
var skill1_name = "???";
var skill1_desc = "Unknown";
var skill2_name = "???";
var skill2_desc = "Unknown";
var skill3_name = "???";
var skill3_desc = "Unknown";

// Tier 1 (Level 5) - Shield variations
if (skill_tier == 1) {
    skill1_name = "Aegis Shield";
    skill1_desc = "Rotating Shield";
    skill2_name = "Phalanx Shield";
    skill2_desc = "Forward Shield";
    skill3_name = "Dome Shield";
    skill3_desc = "Area Shield";
}
// Tier 2 (Level 10) - TODO: Define these
else if (skill_tier == 2) {
    skill1_name = "Skill 2A";
    skill1_desc = "Variant A";
    skill2_name = "Skill 2B";
    skill2_desc = "Variant B";
    skill3_name = "Skill 2C";
    skill3_desc = "Variant C";
}
// Add more tiers as needed

// Button 1
var hover1 = false;
if (input_mode == "mouse" && cursor != noone && point_in_rectangle(cursor_gui_x, cursor_gui_y, button1_x, button_y, button1_x + skill_button_width, button_y + skill_button_height)) {
    hover1 = true;
}

if (selected_skill == 1) {
    draw_set_color(c_aqua);
    draw_rectangle(button1_x, button_y, button1_x + skill_button_width, button_y + skill_button_height, false);
}

if ((input_mode == "keyboard" && current_location == "grid" && current_col == 0) || hover1) {
    draw_set_color(c_yellow);
} else {
    draw_set_color(c_white);
}
draw_rectangle(button1_x, button_y, button1_x + skill_button_width, button_y + skill_button_height, true);

draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_text(button1_x + skill_button_width / 2, text_y, skill1_name);
draw_text(button1_x + skill_button_width / 2, text_y + line_spacing, skill1_desc);

// Button 2
var hover2 = false;
if (input_mode == "mouse" && cursor != noone && point_in_rectangle(cursor_gui_x, cursor_gui_y, button2_x, button_y, button2_x + skill_button_width, button_y + skill_button_height)) {
    hover2 = true;
}

if (selected_skill == 2) {
    draw_set_color(c_aqua);
    draw_rectangle(button2_x, button_y, button2_x + skill_button_width, button_y + skill_button_height, false);
}

if ((input_mode == "keyboard" && current_location == "grid" && current_col == 1) || hover2) {
    draw_set_color(c_yellow);
} else {
    draw_set_color(c_white);
}
draw_rectangle(button2_x, button_y, button2_x + skill_button_width, button_y + skill_button_height, true);

draw_set_color(c_white);
draw_text(button2_x + skill_button_width / 2, text_y, skill2_name);
draw_text(button2_x + skill_button_width / 2, text_y + line_spacing, skill2_desc);

// Button 3
var hover3 = false;
if (input_mode == "mouse" && cursor != noone && point_in_rectangle(cursor_gui_x, cursor_gui_y, button3_x, button_y, button3_x + skill_button_width, button_y + skill_button_height)) {
    hover3 = true;
}

if (selected_skill == 3) {
    draw_set_color(c_aqua);
    draw_rectangle(button3_x, button_y, button3_x + skill_button_width, button_y + skill_button_height, false);
}

if ((input_mode == "keyboard" && current_location == "grid" && current_col == 2) || hover3) {
    draw_set_color(c_yellow);
} else {
    draw_set_color(c_white);
}
draw_rectangle(button3_x, button_y, button3_x + skill_button_width, button_y + skill_button_height, true);

draw_set_color(c_white);
draw_text(button3_x + skill_button_width / 2, text_y, skill3_name);
draw_text(button3_x + skill_button_width / 2, text_y + line_spacing, skill3_desc);

// Draw "Confirm and Resume" button at bottom
var button_text = "Confirm and Resume";
var button_width = string_width(button_text) + 40;
var button_height = 50;
var button_x = menu_x + (menu_width / 2) - (button_width / 2);
var confirm_button_y = button_y + skill_button_height + 40;

var is_hovering = false;
if (input_mode == "mouse" && cursor != noone && point_in_rectangle(cursor_gui_x, cursor_gui_y, button_x, confirm_button_y, button_x + button_width, confirm_button_y + button_height)) {
    is_hovering = true;
}

if ((input_mode == "keyboard" && current_location == "confirm") || is_hovering) {
    draw_set_color(c_yellow);
} else {
    draw_set_color(c_white);
}
draw_rectangle(button_x, confirm_button_y, button_x + button_width, confirm_button_y + button_height, true);

draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text(button_x + button_width / 2, confirm_button_y + button_height / 2, button_text);

// Draw error popup if needed
if (show_error_popup) {
    draw_set_alpha(0.7);
    draw_set_color(c_black);
    draw_rectangle(0, 0, gui_w, gui_h, false);
    draw_set_alpha(1);
    
    var popup_width = 600;
    var popup_height = 200;
    var popup_x = (gui_w / 2) - (popup_width / 2);
    var popup_y = (gui_h / 2) - (popup_height / 2);
    
    draw_set_color(c_black);
    draw_rectangle(popup_x, popup_y, popup_x + popup_width, popup_y + popup_height, false);
    
    draw_set_color(c_red);
    draw_rectangle(popup_x, popup_y, popup_x + popup_width, popup_y + popup_height, true);
    
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(c_white);
    draw_text(popup_x + popup_width / 2, popup_y + 60, error_message);
    
    var ok_button_text = "OK";
    var ok_button_width = 100;
    var ok_button_height = 40;
    var ok_button_x = popup_x + (popup_width / 2) - (ok_button_width / 2);
    var ok_button_y = popup_y + popup_height - ok_button_height - 30;
    
    draw_set_color(c_yellow);
    draw_rectangle(ok_button_x, ok_button_y, ok_button_x + ok_button_width, ok_button_y + ok_button_height, true);
    
    draw_set_color(c_white);
    draw_text(ok_button_x + ok_button_width / 2, ok_button_y + ok_button_height / 2, ok_button_text);
}

// Reset draw settings
draw_set_halign(fa_left);
draw_set_valign(fa_top);