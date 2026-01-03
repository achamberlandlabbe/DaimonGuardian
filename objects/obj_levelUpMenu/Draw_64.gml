/// obj_levelUpMenu Draw GUI Event

// Get GUI dimensions
var gui_w = display_get_gui_width();
var gui_h = display_get_gui_height();

// Menu dimensions - fixed visible height
var menu_width = 900;
var menu_height = 600;
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

// Upgrade button dimensions
var upgrade_button_width = 225;
var upgrade_button_height = 120;
var upgrade_button_y = menu_y + 100;
var row_spacing = 10;
var total_rows = 12;

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

// Get player reference for upgrade ranks
var player = instance_find(obj_player, 0);
var upgrade1_rank = 0;
var upgrade2_rank = 0;
var upgrade3_rank = 0;

if (player != noone && variable_instance_exists(player, "skill_upgrades")) {
    // Base Attack upgrades are in tier 0 (first tier)
    upgrade1_rank = player.skill_upgrades[0, 0];
    upgrade2_rank = player.skill_upgrades[0, 1];
    upgrade3_rank = player.skill_upgrades[0, 2];
}

// Define clipping boundaries
var content_y_start = menu_y + 200;
var content_y_end = menu_y + menu_height - 200;

// Draw all rows (with scrolling)
for (var row = 0; row < total_rows; row++) {
    var current_row_y = upgrade_button_y + (row * (upgrade_button_height + row_spacing)) - scroll_offset;
    
    // Skip rows that are completely outside visible area
    if (current_row_y + upgrade_button_height <= content_y_start || current_row_y >= content_y_end) {
        continue;
    }
    
    // Check if this row is highlighted (keyboard navigation)
    var is_highlighted_row = (input_mode == "keyboard" && current_location == "grid" && current_row == row);
    
    // Row 0 is Base Attack with actual data
    if (row == 0) {
        var text_y = current_row_y + 15;
        var line_spacing = 30;
        
        // Button 1 - Range
        var hover1 = false;
        if (input_mode == "mouse" && cursor != noone && point_in_rectangle(cursor_gui_x, cursor_gui_y, button1_x, current_row_y, button1_x + upgrade_button_width, current_row_y + upgrade_button_height)) {
            hover1 = true;
        }
        
        if (selected_upgrade == 1) {
            draw_set_color(c_aqua);
            draw_rectangle(button1_x, current_row_y, button1_x + upgrade_button_width, current_row_y + upgrade_button_height, false);
        }
        
        if ((is_highlighted_row && current_col == 0) || hover1) {
            draw_set_color(c_yellow);
        } else {
            draw_set_color(c_white);
        }
        draw_rectangle(button1_x, current_row_y, button1_x + upgrade_button_width, current_row_y + upgrade_button_height, true);
        
        draw_set_halign(fa_center);
        draw_set_valign(fa_top);
        draw_set_color(c_white);
        draw_text(button1_x + upgrade_button_width / 2, text_y, "Base Attack");
        draw_text(button1_x + upgrade_button_width / 2, text_y + line_spacing, "+20% Range");
        
        // Display rank or (Max) if at 5/5
        if (upgrade1_rank >= 5) {
            draw_text(button1_x + upgrade_button_width / 2, text_y + line_spacing * 2, string(upgrade1_rank) + "/5 (Max)");
        } else {
            draw_text(button1_x + upgrade_button_width / 2, text_y + line_spacing * 2, string(upgrade1_rank) + "/5 > " + string(upgrade1_rank + 1) + "/5");
        }
        
        // Button 2 - Damage
        var hover2 = false;
        if (input_mode == "mouse" && cursor != noone && point_in_rectangle(cursor_gui_x, cursor_gui_y, button2_x, current_row_y, button2_x + upgrade_button_width, current_row_y + upgrade_button_height)) {
            hover2 = true;
        }
        
        if (selected_upgrade == 2) {
            draw_set_color(c_aqua);
            draw_rectangle(button2_x, current_row_y, button2_x + upgrade_button_width, current_row_y + upgrade_button_height, false);
        }
        
        if ((is_highlighted_row && current_col == 1) || hover2) {
            draw_set_color(c_yellow);
        } else {
            draw_set_color(c_white);
        }
        draw_rectangle(button2_x, current_row_y, button2_x + upgrade_button_width, current_row_y + upgrade_button_height, true);
        
        draw_set_color(c_white);
        draw_text(button2_x + upgrade_button_width / 2, text_y, "Base Attack");
        draw_text(button2_x + upgrade_button_width / 2, text_y + line_spacing, "+20% Damage");
        
        // Display rank or (Max) if at 5/5
        if (upgrade2_rank >= 5) {
            draw_text(button2_x + upgrade_button_width / 2, text_y + line_spacing * 2, string(upgrade2_rank) + "/5 (Max)");
        } else {
            draw_text(button2_x + upgrade_button_width / 2, text_y + line_spacing * 2, string(upgrade2_rank) + "/5 > " + string(upgrade2_rank + 1) + "/5");
        }
        
        // Button 3 - Speed
        var hover3 = false;
        if (input_mode == "mouse" && cursor != noone && point_in_rectangle(cursor_gui_x, cursor_gui_y, button3_x, current_row_y, button3_x + upgrade_button_width, current_row_y + upgrade_button_height)) {
            hover3 = true;
        }
        
        if (selected_upgrade == 3) {
            draw_set_color(c_aqua);
            draw_rectangle(button3_x, current_row_y, button3_x + upgrade_button_width, current_row_y + upgrade_button_height, false);
        }
        
        if ((is_highlighted_row && current_col == 2) || hover3) {
            draw_set_color(c_yellow);
        } else {
            draw_set_color(c_white);
        }
        draw_rectangle(button3_x, current_row_y, button3_x + upgrade_button_width, current_row_y + upgrade_button_height, true);
        
        draw_set_color(c_white);
        draw_text(button3_x + upgrade_button_width / 2, text_y, "Base Attack");
        draw_text(button3_x + upgrade_button_width / 2, text_y + line_spacing, "+20% Speed");
        
        // Display rank or (Max) if at 5/5
        if (upgrade3_rank >= 5) {
            draw_text(button3_x + upgrade_button_width / 2, text_y + line_spacing * 2, string(upgrade3_rank) + "/5 (Max)");
        } else {
            draw_text(button3_x + upgrade_button_width / 2, text_y + line_spacing * 2, string(upgrade3_rank) + "/5 > " + string(upgrade3_rank + 1) + "/5");
        }
    } else {
        // Placeholder rows
        for (var col = 0; col < 3; col++) {
            var btn_x;
            if (col == 0) {
                btn_x = button1_x;
            } else if (col == 1) {
                btn_x = button2_x;
            } else {
                btn_x = button3_x;
            }
            
            // Check for hover on this button (only in mouse mode)
            var is_hovering = false;
            if (input_mode == "mouse" && cursor != noone && point_in_rectangle(cursor_gui_x, cursor_gui_y, btn_x, current_row_y, btn_x + upgrade_button_width, current_row_y + upgrade_button_height)) {
                is_hovering = true;
            }
            
            // Highlight if this is the current position OR if hovering
            if ((is_highlighted_row && current_col == col) || is_hovering) {
                draw_set_color(c_yellow);
            } else {
                draw_set_color(c_white);
            }
            draw_rectangle(btn_x, current_row_y, btn_x + upgrade_button_width, current_row_y + upgrade_button_height, true);
            
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            draw_set_color(c_white);
            draw_text(btn_x + upgrade_button_width / 2, current_row_y + upgrade_button_height / 2, "???");
        }
    }
}

// Draw scrollbar if needed
if (scroll_max > 0) {
    var scrollbar_x = menu_x + menu_width - 15;
    var scrollbar_y = content_y_start;
    var scrollbar_height = content_y_end - content_y_start;
    var scrollbar_width = 10;
    
    // Draw scrollbar track
    draw_set_color(c_dkgray);
    draw_rectangle(scrollbar_x, scrollbar_y, scrollbar_x + scrollbar_width, scrollbar_y + scrollbar_height, false);
    
    // Draw scrollbar thumb
    var thumb_height = max(30, scrollbar_height * (scrollbar_height / (scrollbar_height + scroll_max)));
    var thumb_y = scrollbar_y + ((scroll_offset / scroll_max) * (scrollbar_height - thumb_height));
    
    draw_set_color(c_white);
    draw_rectangle(scrollbar_x, thumb_y, scrollbar_x + scrollbar_width, thumb_y + thumb_height, false);
}

// Draw "Confirm and Resume" button at bottom
var button_text = "Confirm and Resume";
var button_width = string_width(button_text) + 40;
var button_height = 50;
var button_x = menu_x + (menu_width / 2) - (button_width / 2);
var button_y = menu_y + menu_height - button_height - 20;

var is_hovering = false;
if (input_mode == "mouse" && cursor != noone && point_in_rectangle(cursor_gui_x, cursor_gui_y, button_x, button_y, button_x + button_width, button_y + button_height)) {
    is_hovering = true;
}

if ((input_mode == "keyboard" && current_location == "confirm") || is_hovering) {
    draw_set_color(c_yellow);
} else {
    draw_set_color(c_white);
}
draw_rectangle(button_x, button_y, button_x + button_width, button_y + button_height, true);

draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text(button_x + button_width / 2, button_y + button_height / 2, button_text);

// Draw error popup if needed
if (show_error_popup) {
    draw_set_alpha(0.7);
    draw_set_color(c_black);
    draw_rectangle(0, 0, gui_w, gui_h, false);
    draw_set_alpha(1);
    
    var popup_width = 500;
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
    // Use dynamic error message
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