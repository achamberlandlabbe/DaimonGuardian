/// obj_levelUpMenu Step Event

// Get GUI dimensions and button position
var gui_w = display_get_gui_width();
var gui_h = display_get_gui_height();
var menu_width = 900;
var menu_height = 600;
var menu_x = (gui_w / 2) - (menu_width / 2);
var menu_y = (gui_h / 2) - (menu_height / 2);

// Upgrade button dimensions
var upgrade_button_width = 225;
var upgrade_button_height = 120;
var row_spacing = 10;
var total_rows = 12;

// Define visible area boundaries
var upgrade_button_y = menu_y + 100;
var content_y_start = menu_y + 200;
var content_y_end = menu_y + menu_height - 200;
var visible_area_height = content_y_end - content_y_start;

// Calculate total content height and max scroll
var content_height = (upgrade_button_height + row_spacing) * total_rows;
scroll_max = max(0, content_height - visible_area_height);

// Confirm button dimensions
var button_text = "Confirm and Resume";
var button_width = string_width(button_text) + 40;
var button_height = 50;
var button_x = menu_x + (menu_width / 2) - (button_width / 2);
var button_y = menu_y + menu_height - button_height - 20;

// Get cursor position in GUI coordinates
var cursor = instance_find(obj_cursor, 0);
var cursor_gui_x = 0;
var cursor_gui_y = 0;
var clicked = false;

if (cursor != noone) {
    var cam = view_camera[0];
    var cam_x = camera_get_view_x(cam);
    var cam_y = camera_get_view_y(cam);
    var cam_w = camera_get_view_width(cam);
    var cam_h = camera_get_view_height(cam);
    
    cursor_gui_x = ((cursor.x - cam_x) / cam_w) * gui_w;
    cursor_gui_y = ((cursor.y - cam_y) / cam_h) * gui_h;
    
    // Check if mouse was clicked
    if (mouse_check_button_pressed(mb_left)) {
        clicked = true;
    }
    
    // Check if cursor moved - switch to mouse mode (only if not showing popup)
    if (!show_error_popup) {
        if (!variable_instance_exists(id, "last_cursor_x")) {
            last_cursor_x = cursor_gui_x;
            last_cursor_y = cursor_gui_y;
        }
        
        if (cursor_gui_x != last_cursor_x || cursor_gui_y != last_cursor_y) {
            input_mode = "mouse";
            last_cursor_x = cursor_gui_x;
            last_cursor_y = cursor_gui_y;
        }
    }
}

// Handle error popup input - MUST BE FIRST
if (show_error_popup) {
    // Error popup OK button dimensions
    var popup_width = 500;
    var popup_height = 200;
    var popup_x = (gui_w / 2) - (popup_width / 2);
    var popup_y = (gui_h / 2) - (popup_height / 2);
    
    var ok_button_width = 100;
    var ok_button_height = 40;
    var ok_button_x = popup_x + (popup_width / 2) - (ok_button_width / 2);
    var ok_button_y = popup_y + popup_height - ok_button_height - 30;
    
    // Check for mouse click on OK button ONLY
    if (mouse_check_button_pressed(mb_left)) {
        if (cursor != noone && point_in_rectangle(cursor_gui_x, cursor_gui_y, ok_button_x, ok_button_y, ok_button_x + ok_button_width, ok_button_y + ok_button_height)) {
            show_error_popup = false;
            error_message = "";
            playSFX(snd_select, 1, 1, 1);
        }
        // Consume the click regardless - don't process menu
        exit;
    }
    
    // Check for keyboard accept (but NOT mouse button which also triggers accept)
    if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space) || gamepad_button_check_pressed(0, gp_face1)) {
        show_error_popup = false;
        error_message = "";
        playSFX(snd_select, 1, 1, 1);
        exit;
    }
    
    // Don't process any other inputs while popup is showing
    exit;
}

// Track which button is currently hovered in mouse mode
var hovered_row = -1;
var hovered_col = -1;
var hovered_confirm = false;

// Track previous hover state for sound effects
if (!variable_instance_exists(id, "prev_hovered_row")) {
    prev_hovered_row = -1;
    prev_hovered_col = -1;
    prev_hovered_confirm = false;
}

if (input_mode == "mouse" && cursor != noone) {
    // Calculate upgrade button positions
    var total_button_width = upgrade_button_width * 3;
    var available_space = menu_width - total_button_width;
    var spacing = available_space / 4;
    var button1_x = menu_x + spacing;
    var button2_x = menu_x + spacing + upgrade_button_width + spacing;
    var button3_x = menu_x + spacing + (upgrade_button_width + spacing) * 2;
    
    // Check all visible upgrade buttons for hover
    for (var row = 0; row < total_rows; row++) {
        var current_row_y = upgrade_button_y + (row * (upgrade_button_height + row_spacing)) - scroll_offset;
        
        // Skip if row is NOT AT ALL visible within content area
        var row_bottom = current_row_y + upgrade_button_height;
        if (row_bottom <= content_y_start || current_row_y >= content_y_end) {
            continue;
        }
        
        // Check which button is hovered
        if (point_in_rectangle(cursor_gui_x, cursor_gui_y, button1_x, current_row_y, button1_x + upgrade_button_width, current_row_y + upgrade_button_height)) {
            hovered_row = row;
            hovered_col = 0;
            break;
        } else if (point_in_rectangle(cursor_gui_x, cursor_gui_y, button2_x, current_row_y, button2_x + upgrade_button_width, current_row_y + upgrade_button_height)) {
            hovered_row = row;
            hovered_col = 1;
            break;
        } else if (point_in_rectangle(cursor_gui_x, cursor_gui_y, button3_x, current_row_y, button3_x + upgrade_button_width, current_row_y + upgrade_button_height)) {
            hovered_row = row;
            hovered_col = 2;
            break;
        }
    }
    
    // Check if hovering confirm button
    if (point_in_rectangle(cursor_gui_x, cursor_gui_y, button_x, button_y, button_x + button_width, button_y + button_height)) {
        hovered_confirm = true;
    }
    
    // Play sound ONLY if hover changed to a different item
    var hover_changed = false;
    if (hovered_confirm && !prev_hovered_confirm) {
        // Just started hovering confirm button
        hover_changed = true;
    } else if (!hovered_confirm && prev_hovered_confirm) {
        // Stopped hovering confirm button (but might be hovering grid item)
        if (hovered_row >= 0) {
            hover_changed = true;
        }
    } else if (hovered_row >= 0 && (hovered_row != prev_hovered_row || hovered_col != prev_hovered_col)) {
        // Hovering a different grid item
        hover_changed = true;
    } else if (hovered_row < 0 && prev_hovered_row >= 0) {
        // Stopped hovering grid items (but might be on confirm)
        if (hovered_confirm) {
            hover_changed = true;
        }
    }
    
    if (hover_changed) {
        playSFX(snd_switch, 1, 1, 1);
    }
    
    // Update previous hover state
    prev_hovered_row = hovered_row;
    prev_hovered_col = hovered_col;
    prev_hovered_confirm = hovered_confirm;
}

// Handle mouse clicks
if (clicked) {
    // Calculate upgrade button positions
    var total_button_width = upgrade_button_width * 3;
    var available_space = menu_width - total_button_width;
    var spacing = available_space / 4;
    var button1_x = menu_x + spacing;
    var button2_x = menu_x + spacing + upgrade_button_width + spacing;
    var button3_x = menu_x + spacing + (upgrade_button_width + spacing) * 2;
    
    // Check all visible upgrade buttons
    for (var row = 0; row < total_rows; row++) {
        var current_row_y = upgrade_button_y + (row * (upgrade_button_height + row_spacing)) - scroll_offset;
        
        // Skip if row is NOT AT ALL visible within content area
        var row_bottom = current_row_y + upgrade_button_height;
        if (row_bottom <= content_y_start || current_row_y >= content_y_end) {
            continue;
        }
        
        // Check button 1
        if (point_in_rectangle(cursor_gui_x, cursor_gui_y, button1_x, current_row_y, button1_x + upgrade_button_width, current_row_y + upgrade_button_height)) {
            if (row == 0) {
                selected_upgrade = 1;
                current_row = 0;
                current_col = 0;
                current_location = "grid";
                playSFX(snd_select, 1, 1, 1);
            } else {
                // Locked upgrade
                show_error_popup = true;
                error_message = "That upgrade has yet to be unlocked.";
                playSFX(snd_select, 1, 1, 1);
            }
            exit;
        }
        // Check button 2
        else if (point_in_rectangle(cursor_gui_x, cursor_gui_y, button2_x, current_row_y, button2_x + upgrade_button_width, current_row_y + upgrade_button_height)) {
            if (row == 0) {
                selected_upgrade = 2;
                current_row = 0;
                current_col = 1;
                current_location = "grid";
                playSFX(snd_select, 1, 1, 1);
            } else {
                // Locked upgrade
                show_error_popup = true;
                error_message = "That upgrade has yet to be unlocked.";
                playSFX(snd_select, 1, 1, 1);
            }
            exit;
        }
        // Check button 3
        else if (point_in_rectangle(cursor_gui_x, cursor_gui_y, button3_x, current_row_y, button3_x + upgrade_button_width, current_row_y + upgrade_button_height)) {
            if (row == 0) {
                selected_upgrade = 3;
                current_row = 0;
                current_col = 2;
                current_location = "grid";
                playSFX(snd_select, 1, 1, 1);
            } else {
                // Locked upgrade
                show_error_popup = true;
                error_message = "That upgrade has yet to be unlocked.";
                playSFX(snd_select, 1, 1, 1);
            }
            exit;
        }
    }
    
    // Check confirm button - must be hovering to click
    if (point_in_rectangle(cursor_gui_x, cursor_gui_y, button_x, button_y, button_x + button_width, button_y + button_height)) {
        if (selected_upgrade > 0) {
            // Check if the selected upgrade is already maxed out
            var player = instance_find(obj_player, 0);
            if (player != noone && variable_instance_exists(player, "skill_upgrades")) {
                var upgrade_row = floor((selected_upgrade - 1) / 3);
                var upgrade_col = (selected_upgrade - 1) % 3;
                
                // Check if already at max rank (5)
                if (player.skill_upgrades[upgrade_row][upgrade_col] >= 5) {
                    show_error_popup = true;
                    error_message = "This skill cannot be upgraded any further.";
                    playSFX(snd_select, 1, 1, 1);
                    exit;
                }
            }
            
            // APPLY THE UPGRADE - Save to global.playerBuild
            if (player != noone) {
                // Calculate row and column from selected_upgrade (1-3 maps to row 0, cols 0-2)
                var upgrade_row = floor((selected_upgrade - 1) / 3);
                var upgrade_col = (selected_upgrade - 1) % 3;
                
                // Increment the upgrade rank (max 5)
                if (global.playerBuild.skill_upgrades[upgrade_row][upgrade_col] < 5) {
                    global.playerBuild.skill_upgrades[upgrade_row][upgrade_col]++;
                    show_debug_message("Upgraded [" + string(upgrade_row) + "," + string(upgrade_col) + "] to rank " + string(global.playerBuild.skill_upgrades[upgrade_row][upgrade_col]));
                }
                
                // Update player's local reference
                player.skill_upgrades = global.playerBuild.skill_upgrades;
            }
            
            playSFX(snd_select, 1, 1, 1);
            global.isPaused = false;
            global.canPause = true;
            instance_destroy();
        } else {
            // Show error popup - mouse click without selection
            show_error_popup = true;
            error_message = "Please select an upgrade to continue";
            playSFX(snd_select, 1, 1, 1);
        }
        exit;
    }
}

// Handle scrolling with mouse wheel
if (mouse_wheel_up()) {
    scroll_offset -= scroll_speed;
    scroll_offset = max(0, scroll_offset);
}
if (mouse_wheel_down()) {
    scroll_offset += scroll_speed;
    scroll_offset = min(scroll_max, scroll_offset);
}

// Keyboard/gamepad navigation
if (input_check_pressed("left")) {
    // Switch to keyboard mode
    if (input_mode == "mouse") {
        input_mode = "keyboard";
        // Start from where mouse was hovering
        if (hovered_confirm) {
            current_location = "confirm";
        } else if (hovered_row >= 0) {
            current_row = hovered_row;
            current_col = hovered_col;
            current_location = "grid";
        }
    }
    
    if (current_location == "grid") {
        current_col--;
        if (current_col < 0) current_col = 2; // Wrap to rightmost column
        playSFX(snd_switch, 1, 1, 1);
    }
}

if (input_check_pressed("right")) {
    // Switch to keyboard mode
    if (input_mode == "mouse") {
        input_mode = "keyboard";
        // Start from where mouse was hovering
        if (hovered_confirm) {
            current_location = "confirm";
        } else if (hovered_row >= 0) {
            current_row = hovered_row;
            current_col = hovered_col;
            current_location = "grid";
        }
    }
    
    if (current_location == "grid") {
        current_col++;
        if (current_col > 2) current_col = 0; // Wrap to leftmost column
        playSFX(snd_switch, 1, 1, 1);
    }
}

if (input_check_pressed("down")) {
    // Switch to keyboard mode
    if (input_mode == "mouse") {
        input_mode = "keyboard";
        // Start from where mouse was hovering
        if (hovered_confirm) {
            current_location = "confirm";
        } else if (hovered_row >= 0) {
            current_row = hovered_row;
            current_col = hovered_col;
            current_location = "grid";
        }
    }
    
    if (current_location == "grid") {
        current_row++;
        if (current_row >= total_rows) {
            // Move to confirm button
            current_location = "confirm";
            playSFX(snd_switch, 1, 1, 1);
        } else {
            // Check if the new row would be visible
            var new_row_y = upgrade_button_y + (current_row * (upgrade_button_height + row_spacing)) - scroll_offset;
            var new_row_bottom = new_row_y + upgrade_button_height;
            
            // If the new row would be below the visible area, scroll down
            if (new_row_bottom > content_y_end) {
                scroll_offset += scroll_speed;
                scroll_offset = min(scroll_max, scroll_offset);
            }
            playSFX(snd_switch, 1, 1, 1);
        }
    }
}

if (input_check_pressed("up")) {
    // Switch to keyboard mode
    if (input_mode == "mouse") {
        input_mode = "keyboard";
        // Start from where mouse was hovering
        if (hovered_confirm) {
            current_location = "confirm";
        } else if (hovered_row >= 0) {
            current_row = hovered_row;
            current_col = hovered_col;
            current_location = "grid";
        }
    }
    
    if (current_location == "confirm") {
        // Move back to grid at bottom row
        current_location = "grid";
        current_row = total_rows - 1;
        playSFX(snd_switch, 1, 1, 1);
    } else if (current_location == "grid") {
        if (current_row > 0) {
            current_row--;
            
            // Check if the new row would be visible
            var new_row_y = upgrade_button_y + (current_row * (upgrade_button_height + row_spacing)) - scroll_offset;
            
            // If the new row would be above the visible area, scroll up
            if (new_row_y < content_y_start) {
                scroll_offset -= scroll_speed;
                scroll_offset = max(0, scroll_offset);
            }
            playSFX(snd_switch, 1, 1, 1);
        }
        // If current_row is 0, stay at row 0 (don't move or scroll)
    }
}

// Accept button (keyboard/gamepad) - select highlighted button
if (input_check_pressed("accept")) {
    var should_process_accept = true;
    
    // Switch to keyboard mode
    if (input_mode == "mouse") {
        // Check if mouse is actually hovering over something
        if (hovered_confirm) {
            input_mode = "keyboard";
            current_location = "confirm";
        } else if (hovered_row >= 0 && hovered_col >= 0) {
            input_mode = "keyboard";
            current_row = hovered_row;
            current_col = hovered_col;
            current_location = "grid";
        } else {
            // Mouse clicked but not hovering over anything - ignore the accept
            should_process_accept = false;
        }
    }
    
    if (should_process_accept) {
        if (current_location == "grid") {
            // Check if this is row 0 (unlocked) or other rows (locked)
            if (current_row == 0) {
                // Only row 0 has actual upgrades
                selected_upgrade = (current_row * 3) + current_col + 1; // 1, 2, or 3
                playSFX(snd_select, 1, 1, 1);
            } else {
                // Locked upgrade
                show_error_popup = true;
                error_message = "That upgrade has yet to be unlocked.";
                playSFX(snd_select, 1, 1, 1);
            }
        } else if (current_location == "confirm") {
            // Confirm button
            if (selected_upgrade > 0) {
                // Check if the selected upgrade is already maxed out
                var player = instance_find(obj_player, 0);
                if (player != noone && variable_instance_exists(player, "skill_upgrades")) {
                    var upgrade_row = floor((selected_upgrade - 1) / 3);
                    var upgrade_col = (selected_upgrade - 1) % 3;
                    
                    // Check if already at max rank (5)
                    if (player.skill_upgrades[upgrade_row][upgrade_col] >= 5) {
                        show_error_popup = true;
                        error_message = "This skill cannot be upgraded any further.";
                        playSFX(snd_select, 1, 1, 1);
                        exit;
                    }
                }
                
                // APPLY THE UPGRADE - Save to global.playerBuild
                if (player != noone) {
                    // Calculate row and column from selected_upgrade (1-3 maps to row 0, cols 0-2)
                    var upgrade_row = floor((selected_upgrade - 1) / 3);
                    var upgrade_col = (selected_upgrade - 1) % 3;
                    
                    // Increment the upgrade rank (max 5)
                    if (global.playerBuild.skill_upgrades[upgrade_row][upgrade_col] < 5) {
                        global.playerBuild.skill_upgrades[upgrade_row][upgrade_col]++;
                        show_debug_message("Upgraded [" + string(upgrade_row) + "," + string(upgrade_col) + "] to rank " + string(global.playerBuild.skill_upgrades[upgrade_row][upgrade_col]));
                    }
                    
                    // Update player's local reference
                    player.skill_upgrades = global.playerBuild.skill_upgrades;
                }
                
                playSFX(snd_select, 1, 1, 1);
                global.isPaused = false;
                global.canPause = true;
                instance_destroy();
            } else {
                // Show error popup
                show_error_popup = true;
                error_message = "Please select an upgrade to continue";
                playSFX(snd_select, 1, 1, 1);
            }
        }
    }
}