/// obj_skillSelectionMenu Step Event

// Get GUI dimensions and button position
var gui_w = display_get_gui_width();
var gui_h = display_get_gui_height();
var menu_width = 900;
var menu_height = 400; // Shorter than upgrade menu since only 1 row
var menu_x = (gui_w / 2) - (menu_width / 2);
var menu_y = (gui_h / 2) - (menu_height / 2);

// Skill button dimensions
var skill_button_width = 225;
var skill_button_height = 120;

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
    var popup_width = 600;
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
    
    // Check for keyboard accept
    if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space) || gamepad_button_check_pressed(0, gp_face1)) {
        show_error_popup = false;
        error_message = "";
        exit;
    }
    
    // Don't process any other inputs while popup is showing
    exit;
}

// Track which button is currently hovered in mouse mode
var hovered_col = -1;
var hovered_confirm = false;

// Calculate skill button positions (3 buttons in 1 row)
var total_button_width = skill_button_width * 3;
var available_space = menu_width - total_button_width;
var spacing = available_space / 4;
var button1_x = menu_x + spacing;
var button2_x = menu_x + spacing + skill_button_width + spacing;
var button3_x = menu_x + spacing + (skill_button_width + spacing) * 2;
var button_y = menu_y + 100; // Position of the skill buttons

if (input_mode == "mouse" && cursor != noone) {
    // Check which button is hovered
    if (point_in_rectangle(cursor_gui_x, cursor_gui_y, button1_x, button_y, button1_x + skill_button_width, button_y + skill_button_height)) {
        hovered_col = 0;
    } else if (point_in_rectangle(cursor_gui_x, cursor_gui_y, button2_x, button_y, button2_x + skill_button_width, button_y + skill_button_height)) {
        hovered_col = 1;
    } else if (point_in_rectangle(cursor_gui_x, cursor_gui_y, button3_x, button_y, button3_x + skill_button_width, button_y + skill_button_height)) {
        hovered_col = 2;
    }
    
    // Check if hovering confirm button
    if (point_in_rectangle(cursor_gui_x, cursor_gui_y, button_x, button_y + skill_button_height + 40, button_x + button_width, button_y + skill_button_height + 40 + button_height)) {
        hovered_confirm = true;
    }
}

// Handle mouse clicks
if (clicked) {
    // Check button 1
    if (point_in_rectangle(cursor_gui_x, cursor_gui_y, button1_x, button_y, button1_x + skill_button_width, button_y + skill_button_height)) {
        selected_skill = 1;
        current_col = 0;
        current_location = "grid";
        exit;
    }
    // Check button 2
    else if (point_in_rectangle(cursor_gui_x, cursor_gui_y, button2_x, button_y, button2_x + skill_button_width, button_y + skill_button_height)) {
        selected_skill = 2;
        current_col = 1;
        current_location = "grid";
        exit;
    }
    // Check button 3
    else if (point_in_rectangle(cursor_gui_x, cursor_gui_y, button3_x, button_y, button3_x + skill_button_width, button_y + skill_button_height)) {
        selected_skill = 3;
        current_col = 2;
        current_location = "grid";
        exit;
    }
    
    // Check confirm button
    var confirm_y = button_y + skill_button_height + 40;
    if (point_in_rectangle(cursor_gui_x, cursor_gui_y, button_x, confirm_y, button_x + button_width, confirm_y + button_height)) {
        if (selected_skill > 0) {
            // UNLOCK THE SELECTED SKILL
            // TODO: Add the selected skill to global.playerBuild.ownedSkills
            // For now, just close the menu
            show_debug_message("Selected skill " + string(selected_skill) + " for tier " + string(skill_tier));
            
            global.isPaused = false;
            global.canPause = true;
            instance_destroy();
        } else {
            // Show error popup
            show_error_popup = true;
            error_message = "Please select a skill to continue";
        }
        exit;
    }
}

// Keyboard/gamepad navigation
if (input_check_pressed("left")) {
    // Switch to keyboard mode
    if (input_mode == "mouse") {
        input_mode = "keyboard";
        if (hovered_confirm) {
            current_location = "confirm";
        } else if (hovered_col >= 0) {
            current_col = hovered_col;
            current_location = "grid";
        }
    }
    
    if (current_location == "grid") {
        current_col--;
        if (current_col < 0) current_col = 2; // Wrap to rightmost
    }
}

if (input_check_pressed("right")) {
    // Switch to keyboard mode
    if (input_mode == "mouse") {
        input_mode = "keyboard";
        if (hovered_confirm) {
            current_location = "confirm";
        } else if (hovered_col >= 0) {
            current_col = hovered_col;
            current_location = "grid";
        }
    }
    
    if (current_location == "grid") {
        current_col++;
        if (current_col > 2) current_col = 0; // Wrap to leftmost
    }
}

if (input_check_pressed("down")) {
    // Switch to keyboard mode
    if (input_mode == "mouse") {
        input_mode = "keyboard";
        if (hovered_confirm) {
            current_location = "confirm";
        } else if (hovered_col >= 0) {
            current_col = hovered_col;
            current_location = "grid";
        }
    }
    
    if (current_location == "grid") {
        // Move to confirm button
        current_location = "confirm";
    }
}

if (input_check_pressed("up")) {
    // Switch to keyboard mode
    if (input_mode == "mouse") {
        input_mode = "keyboard";
        if (hovered_confirm) {
            current_location = "confirm";
        } else if (hovered_col >= 0) {
            current_col = hovered_col;
            current_location = "grid";
        }
    }
    
    if (current_location == "confirm") {
        // Move back to grid
        current_location = "grid";
    }
}

// Accept button (keyboard/gamepad)
if (input_check_pressed("accept")) {
    var should_process_accept = true;
    
    // Switch to keyboard mode
    if (input_mode == "mouse") {
        if (hovered_confirm) {
            input_mode = "keyboard";
            current_location = "confirm";
        } else if (hovered_col >= 0) {
            input_mode = "keyboard";
            current_col = hovered_col;
            current_location = "grid";
        } else {
            should_process_accept = false;
        }
    }
    
    if (should_process_accept) {
        if (current_location == "grid") {
            // Select the current skill
            selected_skill = current_col + 1; // 1, 2, or 3
        } else if (current_location == "confirm") {
            // Confirm button
            if (selected_skill > 0) {
                // UNLOCK THE SELECTED SKILL
                // TODO: Add the selected skill to global.playerBuild.ownedSkills
                show_debug_message("Selected skill " + string(selected_skill) + " for tier " + string(skill_tier));
                
                global.isPaused = false;
                global.canPause = true;
                instance_destroy();
            } else {
                // Show error popup
                show_error_popup = true;
                error_message = "Please select a skill to continue";
            }
        }
    }
}