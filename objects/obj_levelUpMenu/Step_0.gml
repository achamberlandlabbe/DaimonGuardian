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
        }
        // Consume the click regardless - don't process menu
        exit;
    }
    
    // Check for keyboard accept (but NOT mouse button which also triggers accept)
    if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space) || gamepad_button_check_pressed(0, gp_face1)) {
        show_error_popup = false;
        error_message = "";
        exit;
    }
    
    // Don't process any other inputs while popup is showing
    exit;
}

// Track which button is currently hovered in mouse mode
var hovered_row = -1;
var hovered_col = -1;
var hovered_confirm = false;

if (input_mode == "mouse" && cursor != noone) {
    // Calculate upgrade button positions
    var total_button_width = upgrade_button_width * 3;
    var available_space = menu_width - total_button_width;
    var spacing = available_space / 4;
    var button1_x = menu_x + spacing;
    var button2_x = menu_x + spacing + upgrade_button_width + spacing;
    var button3_x = menu_x + spacing + (upgrade_button_width + spacing) * 2;
    
    show_debug_message("=== HOVER CHECK: cursor at " + string(cursor_gui_x) + ", " + string(cursor_gui_y));
    
    // Check all visible upgrade buttons for hover
    for (var row = 0; row < total_rows; row++) {
        var current_row_y = upgrade_button_y + (row * (upgrade_button_height + row_spacing)) - scroll_offset;
        
        show_debug_message("Hover Row " + string(row) + ": y=" + string(current_row_y) + " to " + string(current_row_y + upgrade_button_height) + " | content_y: " + string(content_y_start) + " to " + string(content_y_end));
        
        // Skip if row is NOT AT ALL visible within content area
        // A row is hoverable if ANY part of it overlaps with the content area
        // Row overlaps if: row_bottom > content_start AND row_top < content_end
        var row_bottom = current_row_y + upgrade_button_height;
        if (row_bottom <= content_y_start || current_row_y >= content_y_end) {
            show_debug_message("  SKIPPED (not visible)");
            continue;
        }
        
        show_debug_message("  CHECKING hover for row " + string(row));
        
        // Check which button is hovered
        if (point_in_rectangle(cursor_gui_x, cursor_gui_y, button1_x, current_row_y, button1_x + upgrade_button_width, current_row_y + upgrade_button_height)) {
            show_debug_message("  HOVER MATCH button 1!");
            hovered_row = row;
            hovered_col = 0;
            break;
        } else if (point_in_rectangle(cursor_gui_x, cursor_gui_y, button2_x, current_row_y, button2_x + upgrade_button_width, current_row_y + upgrade_button_height)) {
            show_debug_message("  HOVER MATCH button 2!");
            hovered_row = row;
            hovered_col = 1;
            break;
        } else if (point_in_rectangle(cursor_gui_x, cursor_gui_y, button3_x, current_row_y, button3_x + upgrade_button_width, current_row_y + upgrade_button_height)) {
            show_debug_message("  HOVER MATCH button 3!");
            hovered_row = row;
            hovered_col = 2;
            break;
        }
    }
    
    show_debug_message("Final hover state: row=" + string(hovered_row) + ", col=" + string(hovered_col));
    
    // Check if hovering confirm button
    if (point_in_rectangle(cursor_gui_x, cursor_gui_y, button_x, button_y, button_x + button_width, button_y + button_height)) {
        hovered_confirm = true;
    }
}

// Handle mouse clicks
if (clicked) {
    show_debug_message("=== CLICK at GUI position: " + string(cursor_gui_x) + ", " + string(cursor_gui_y) + " ===");
    show_debug_message("Current selected_upgrade BEFORE: " + string(selected_upgrade));
    
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
        
        show_debug_message("Click Row " + string(row) + ": y=" + string(current_row_y) + " to " + string(current_row_y + upgrade_button_height) + " | content_y: " + string(content_y_start) + " to " + string(content_y_end));
        
        // Skip if row is NOT AT ALL visible within content area
        // A row is clickable if ANY part of it overlaps with the content area
        // Row overlaps if: row_bottom > content_start AND row_top < content_end
        var row_bottom = current_row_y + upgrade_button_height;
        if (row_bottom <= content_y_start || current_row_y >= content_y_end) {
            show_debug_message("  SKIPPED (not visible)");
            continue;
        }
        
        show_debug_message("  CHECKING buttons for row " + string(row));
        show_debug_message("  Button 1: x=" + string(button1_x) + "-" + string(button1_x + upgrade_button_width) + " y=" + string(current_row_y) + "-" + string(current_row_y + upgrade_button_height));
        show_debug_message("  Button 2: x=" + string(button2_x) + "-" + string(button2_x + upgrade_button_width) + " y=" + string(current_row_y) + "-" + string(current_row_y + upgrade_button_height));
        show_debug_message("  Button 3: x=" + string(button3_x) + "-" + string(button3_x + upgrade_button_width) + " y=" + string(current_row_y) + "-" + string(current_row_y + upgrade_button_height));
        
        // Check button 1
        if (point_in_rectangle(cursor_gui_x, cursor_gui_y, button1_x, current_row_y, button1_x + upgrade_button_width, current_row_y + upgrade_button_height)) {
            show_debug_message("  CLICK MATCH button 1!");
            if (row == 0) {
                show_debug_message("Clicked upgrade button 1");
                selected_upgrade = 1;
                current_row = 0;
                current_col = 0;
                current_location = "grid";
            } else {
                // Locked upgrade
                show_error_popup = true;
                error_message = "That upgrade has yet to be unlocked.";
            }
            exit;
        }
        // Check button 2
        else if (point_in_rectangle(cursor_gui_x, cursor_gui_y, button2_x, current_row_y, button2_x + upgrade_button_width, current_row_y + upgrade_button_height)) {
            if (row == 0) {
                show_debug_message("Clicked upgrade button 2");
                selected_upgrade = 2;
                current_row = 0;
                current_col = 1;
                current_location = "grid";
            } else {
                // Locked upgrade
                show_error_popup = true;
                error_message = "That upgrade has yet to be unlocked.";
            }
            exit;
        }
        // Check button 3
        else if (point_in_rectangle(cursor_gui_x, cursor_gui_y, button3_x, current_row_y, button3_x + upgrade_button_width, current_row_y + upgrade_button_height)) {
            if (row == 0) {
                show_debug_message("Clicked upgrade button 3");
                selected_upgrade = 3;
                current_row = 0;
                current_col = 2;
                current_location = "grid";
            } else {
                // Locked upgrade
                show_error_popup = true;
                error_message = "That upgrade has yet to be unlocked.";
            }
            exit;
        }
    }
    
    show_debug_message("=== Click loop finished. selected_upgrade = " + string(selected_upgrade));
    
    // Check confirm button - must be hovering to click
    if (point_in_rectangle(cursor_gui_x, cursor_gui_y, button_x, button_y, button_x + button_width, button_y + button_height)) {
        show_debug_message("Clicked confirm button. selected_upgrade = " + string(selected_upgrade));
        if (selected_upgrade > 0) {
            // Apply the selected upgrade
            show_debug_message("Applied upgrade " + string(selected_upgrade));
            
            global.isPaused = false;
            global.canPause = true;
            instance_destroy();
        } else {
            // Show error popup - mouse click without selection
            show_debug_message("Showing error popup - no upgrade selected");
            show_error_popup = true;
            error_message = "Please select an upgrade to continue";
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
        } else {
            // Check if the new row would be visible
            var new_row_y = upgrade_button_y + (current_row * (upgrade_button_height + row_spacing)) - scroll_offset;
            var new_row_bottom = new_row_y + upgrade_button_height;
            
            // If the new row would be below the visible area, scroll down
            if (new_row_bottom > content_y_end) {
                scroll_offset += scroll_speed;
                scroll_offset = min(scroll_max, scroll_offset);
            }
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
            // This prevents clicking below visible area from selecting the default highlighted button
            should_process_accept = false;
        }
    }
    
    if (should_process_accept) {
        if (current_location == "grid") {
            // Check if this is row 0 (unlocked) or other rows (locked)
            if (current_row == 0) {
                // Only row 0 has actual upgrades
                selected_upgrade = (current_row * 3) + current_col + 1; // 1, 2, or 3
            } else {
                // Locked upgrade
                show_error_popup = true;
                error_message = "That upgrade has yet to be unlocked.";
            }
        } else if (current_location == "confirm") {
        // Confirm button
        if (selected_upgrade > 0) {
            // Apply the selected upgrade
            show_debug_message("Applied upgrade " + string(selected_upgrade));
            
            global.isPaused = false;
            global.canPause = true;
            instance_destroy();
        } else {
            // Show error popup
            show_error_popup = true;
            error_message = "Please select an upgrade to continue";
        }
        }
    }
}