/// obj_options Step Event

#region Escape Key Handler
// Always allow closing the menu with Escape, even during confirmation
if (keyboard_check_pressed(vk_escape)) {
    instance_destroy();
    exit;
}
#endregion

#region Main Menu Confirmation Dialog
if (show_main_menu_confirmation) {
    // Get cursor position in GUI space
    var cursor = instance_find(obj_cursor, 0);
    var cursor_gui_x = 0;
    var cursor_gui_y = 0;
    
    if (cursor != noone) {
        // Convert cursor room position to GUI position
        var cam = view_camera[0];
        var cam_x = camera_get_view_x(cam);
        var cam_y = camera_get_view_y(cam);
        var cam_w = camera_get_view_width(cam);
        var cam_h = camera_get_view_height(cam);
        
        var gui_w = display_get_gui_width();
        var gui_h = display_get_gui_height();
        
        // Convert cursor position from room to GUI coordinates
        cursor_gui_x = ((cursor.x - cam_x) / cam_w) * gui_w;
        cursor_gui_y = ((cursor.y - cam_y) / cam_h) * gui_h;
        
        var conf_width = 630;
        var conf_height = 300;
        var conf_x = (gui_w / 2) - (conf_width / 2);
        var conf_y = (gui_h / 2) - (conf_height / 2);
        var button_width = 100;
        var button_height = 40;
        var button_y = conf_y + conf_height - button_height - 20;
        var no_x = conf_x + conf_width / 2 - button_width - 10;
        var yes_x = conf_x + conf_width / 2 + 10;

        if (point_in_rectangle(cursor_gui_x, cursor_gui_y, no_x, button_y, no_x + button_width, button_y + button_height)) {
            main_menu_selection = "no";
        }
        if (point_in_rectangle(cursor_gui_x, cursor_gui_y, yes_x, button_y, yes_x + button_width, button_y + button_height)) {
            main_menu_selection = "yes";
        }
    }

    // Navigation
    if (input_check_pressed("left", 0)) main_menu_selection = "no";
    if (input_check_pressed("right", 0)) main_menu_selection = "yes";

    // Confirm
    if (input_check_pressed("accept", 0)) {
        show_debug_message("Accept pressed! Selection: " + main_menu_selection);
        
        var clicked_on_button = true; // Default to true for keyboard
        
        // Only check cursor position if cursor exists AND we're using mouse input
        if (cursor != noone && mouse_check_button_pressed(mb_left)) {
            var gui_w = display_get_gui_width();
            var gui_h = display_get_gui_height();
            var conf_width = 630;
            var conf_height = 300;
            var conf_x = (gui_w / 2) - (conf_width / 2);
            var conf_y = (gui_h / 2) - (conf_height / 2);
            var button_width = 100;
            var button_height = 40;
            var button_y = conf_y + conf_height - button_height - 20;
            var no_x = conf_x + conf_width / 2 - button_width - 10;
            var yes_x = conf_x + conf_width / 2 + 10;

            // For mouse click, require clicking on a button
            clicked_on_button = false;
            if (point_in_rectangle(cursor_gui_x, cursor_gui_y, no_x, button_y, no_x + button_width, button_y + button_height) ||
                point_in_rectangle(cursor_gui_x, cursor_gui_y, yes_x, button_y, yes_x + button_width, button_y + button_height)) {
                clicked_on_button = true;
            }
        }
        
        if (clicked_on_button) {
            show_debug_message("Button was clicked! Executing selection: " + main_menu_selection);
            if (main_menu_selection == "yes") {
                show_debug_message("Going to title screen...");
                room_goto(roomTitleScreen);
            } else {
                show_debug_message("Closing confirmation dialog...");
                show_main_menu_confirmation = false;
            }
        }
    }

    // Cancel with back button
    if (input_check_pressed("back", 0)) {
        show_main_menu_confirmation = false;
    }

    exit; // Don't process other inputs during confirmation
}
#endregion

#region Cursor-Based Menu Selection
var cursor = instance_find(obj_cursor, 0);
if (cursor != noone) {
    // Menu positioning (matching Draw GUI Event calculations)
    draw_set_font(Font1);

    var title_y = menu_y + 20;
    var title_height = 80;
    var title_bottom = title_y + title_height + 90;
    var menu_bottom = menu_y + menu_height - 20;
    var available_height = menu_bottom - title_bottom;
    var total_gaps = array_length(optionsList) + 1;
    var equal_spacing = available_height / total_gaps;

    var roomName = room_get_name(room);

    // Check each option's bounding box
    for (var i = 0; i < array_length(optionsList); i++) {
        var option_y = title_bottom + ((i + 1) * equal_spacing);

        // Move the first five options down by 20px, move Main Menu up by 20px
        if (i < 5) {
            option_y -= 80;
        } else if (i == 5) {
            option_y -= 20;
        }

        var option_x = menu_x + menu_width / 2;
        var option_width = string_width(optionsList[i]);
        var option_height = string_height(optionsList[i]);

        // Check if cursor is inside this option's rectangle (centered text)
        if (cursor.x >= option_x - option_width/2 && cursor.x <= option_x + option_width/2 &&
            cursor.y >= option_y && cursor.y <= option_y + option_height) {
            optionsMenuSelection = i;
            break;
        }
    }

    // Cursor clicking on slider bars for volume and sensitivity options (first 4 options)
    if (optionsMenuSelection >= 0 && optionsMenuSelection <= 3) {
        var option_y = title_bottom + ((optionsMenuSelection + 1) * equal_spacing);

        // Move the first five options down by 20px
        if (optionsMenuSelection < 5) {
            option_y -= 80;
        }

        var value_y = option_y + 30;
        var slider_x = menu_x + menu_width / 2 - 150;
        var slider_width = 300;
        var slider_height = 30;

        // Check if cursor is over slider area and mouse button held
        if (cursor.x >= slider_x && cursor.x <= slider_x + slider_width &&
            cursor.y >= value_y - slider_height/2 && cursor.y <= value_y + slider_height/2) {

            if (mouse_check_button(mb_left)) {
                // Calculate value based on cursor position on slider
                var slider_percent = clamp((cursor.x - slider_x) / slider_width, 0, 1);

                switch(optionsMenuSelection) {
                    case 0: // Master volume
                        global.saveData.masterVolume = slider_percent;
                        autoSave();
                        break;
                    case 1: // Music volume
                        global.saveData.musicVolume = slider_percent;
                        autoSave();
                        break;
                    case 2: // Sound volume
                        global.saveData.soundVolume = slider_percent;
                        autoSave();
                        break;
                    case 3: // Cursor sensitivity (-50% to +50% in 10% increments)
                        // Map 0-1 slider to -0.5 to +0.5 range
                        var sensitivity_value = (slider_percent * 1.0) - 0.5;
                        // Round to nearest 10% increment
                        sensitivity_value = round(sensitivity_value * 10) / 10;
                        global.saveData.cursorSensitivity = sensitivity_value;
                        autoSave();
                        break;
                }
            }
        }
    }
}
#endregion

#region Keyboard Navigation
// Movement between buttons
if (input_check_pressed("up", 0) && optionsMenuSelection > 0) {
    optionsMenuSelection--;
    playSFX(snd_switch, 1, 1, 1);
}
else if (input_check_pressed("up", 0) && optionsMenuSelection == 0) {
    optionsMenuSelection = optionsMenuMaxSelection;
    playSFX(snd_switch, 1, 1, 1);
}
else if (input_check_pressed("down", 0) && optionsMenuSelection < optionsMenuMaxSelection) {
    optionsMenuSelection++;
    playSFX(snd_switch, 1, 1, 1);
}
else if (input_check_pressed("down", 0)) {
    optionsMenuSelection = 0;
    playSFX(snd_switch, 1, 1, 1);
}
#endregion

#region Option Actions
switch(optionsMenuSelection) {
    case 0: // Master volume
        if (input_check_released("left", 0) && global.saveData.masterVolume >= VOLUME_STEP) {
            global.saveData.masterVolume -= VOLUME_STEP;
            autoSave();
        }
        else if (input_check_released("right", 0) && global.saveData.masterVolume <= 1 - VOLUME_STEP) {
            global.saveData.masterVolume += VOLUME_STEP;
            autoSave();
        }
        break;
    case 1: // Music volume
        if (input_check_released("left", 0) && global.saveData.musicVolume >= VOLUME_STEP) {
            global.saveData.musicVolume -= VOLUME_STEP;
            autoSave();
        }
        else if (input_check_released("right", 0) && global.saveData.musicVolume <= 1 - VOLUME_STEP) {
            global.saveData.musicVolume += VOLUME_STEP;
            autoSave();
        }
        break;
    case 2: // Sound volume
        if (input_check_released("left", 0) && global.saveData.soundVolume >= VOLUME_STEP) {
            global.saveData.soundVolume -= VOLUME_STEP;
            autoSave();
        }
        else if (input_check_released("right", 0) && global.saveData.soundVolume <= 1 - VOLUME_STEP) {
            global.saveData.soundVolume += VOLUME_STEP;
            autoSave();
        }
        break;
    case 3: // Cursor sensitivity
        if (input_check_released("left", 0) && global.saveData.cursorSensitivity > -0.5) {
            global.saveData.cursorSensitivity -= 0.1; // 10% decrement
            global.saveData.cursorSensitivity = clamp(global.saveData.cursorSensitivity, -0.5, 0.5);
            autoSave();
        }
        else if (input_check_released("right", 0) && global.saveData.cursorSensitivity < 0.5) {
            global.saveData.cursorSensitivity += 0.1; // 10% increment
            global.saveData.cursorSensitivity = clamp(global.saveData.cursorSensitivity, -0.5, 0.5);
            autoSave();
        }
        break;
    case 4: // Vibration
        if (input_check_pressed("accept", 0)) {
            global.saveData.vibrations = !global.saveData.vibrations;
            autoSave();
        }
        break;
    case 5: // Main Menu
        if (input_check_pressed("accept", 0)) {
            show_main_menu_confirmation = true;
            main_menu_selection = "no";
        }
        break;
}
#endregion