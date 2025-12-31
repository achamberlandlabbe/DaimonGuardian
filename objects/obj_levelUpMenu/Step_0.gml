/// obj_levelUpMenu Step Event

// Get GUI dimensions and button position
var gui_w = display_get_gui_width();
var gui_h = display_get_gui_height();
var menu_width = 600;
var menu_height = 400;
var menu_x = (gui_w / 2) - (menu_width / 2);
var menu_y = (gui_h / 2) - (menu_height / 2);

// Upgrade button dimensions
var upgrade_button_width = 150;
var upgrade_button_height = 80;
var upgrade_button_y = menu_y + 120;

var total_button_width = upgrade_button_width * 3;
var available_space = menu_width - total_button_width;
var spacing = available_space / 4;

var button1_x = menu_x + spacing;
var button2_x = menu_x + spacing + upgrade_button_width + spacing;
var button3_x = menu_x + spacing + (upgrade_button_width + spacing) * 2;

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
}

// Handle error popup input
if (show_error_popup) {
    // Error popup OK button dimensions
    var popup_width = 400;
    var popup_height = 200;
    var popup_x = (gui_w / 2) - (popup_width / 2);
    var popup_y = (gui_h / 2) - (popup_height / 2);
    
    var ok_button_width = 100;
    var ok_button_height = 40;
    var ok_button_x = popup_x + (popup_width / 2) - (ok_button_width / 2);
    var ok_button_y = popup_y + popup_height - ok_button_height - 30;
    
    // Check for clicks on OK button or accept key
    if (input_check_pressed("accept") || 
        (clicked && cursor != noone && point_in_rectangle(cursor_gui_x, cursor_gui_y, ok_button_x, ok_button_y, ok_button_x + ok_button_width, ok_button_y + ok_button_height))) {
        show_error_popup = false;
    }
    
    // Don't process menu inputs while popup is showing
    exit;
}

// Handle mouse clicks FIRST (before keyboard input)
if (clicked) {
    show_debug_message("Mouse clicked at GUI position: " + string(cursor_gui_x) + ", " + string(cursor_gui_y));
    show_debug_message("Current selected_upgrade: " + string(selected_upgrade));
    
    // Check upgrade button 1
    if (point_in_rectangle(cursor_gui_x, cursor_gui_y, button1_x, upgrade_button_y, button1_x + upgrade_button_width, upgrade_button_y + upgrade_button_height)) {
        show_debug_message("Clicked upgrade button 1");
        selected_upgrade = 1;
        exit; // Exit to prevent other input processing
    }
    // Check upgrade button 2
    else if (point_in_rectangle(cursor_gui_x, cursor_gui_y, button2_x, upgrade_button_y, button2_x + upgrade_button_width, upgrade_button_y + upgrade_button_height)) {
        show_debug_message("Clicked upgrade button 2");
        selected_upgrade = 2;
        exit; // Exit to prevent other input processing
    }
    // Check upgrade button 3
    else if (point_in_rectangle(cursor_gui_x, cursor_gui_y, button3_x, upgrade_button_y, button3_x + upgrade_button_width, upgrade_button_y + upgrade_button_height)) {
        show_debug_message("Clicked upgrade button 3");
        selected_upgrade = 3;
        exit; // Exit to prevent other input processing
    }
    // Check confirm button
    else if (point_in_rectangle(cursor_gui_x, cursor_gui_y, button_x, button_y, button_x + button_width, button_y + button_height)) {
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
        }
        exit; // Exit to prevent other input processing
    }
}

// Keyboard/gamepad navigation (only process if no mouse click happened)
if (input_check_pressed("left")) {
    highlighted_button--;
    if (highlighted_button < 1) highlighted_button = 4;
}

if (input_check_pressed("right")) {
    highlighted_button++;
    if (highlighted_button > 4) highlighted_button = 1;
}

if (input_check_pressed("down")) {
    // Move to confirm button
    highlighted_button = 4;
}

if (input_check_pressed("up")) {
    // Move to first upgrade button
    if (highlighted_button == 4) {
        highlighted_button = 1;
    }
}

// Accept button (keyboard/gamepad) - select highlighted button
if (input_check_pressed("accept")) {
    if (highlighted_button >= 1 && highlighted_button <= 3) {
        // Select upgrade
        selected_upgrade = highlighted_button;
    } else if (highlighted_button == 4) {
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
        }
    }
}