/// obj_victory Step Event - Guardian Daimon
// Handle game over screen menu navigation

// Safety check - ensure variables exist (Create event may not have run yet)
if (!variable_instance_exists(id, "menu_options") || !variable_instance_exists(id, "selected_option")) {
    exit;
}

// Track previous selection for sound effects
var prev_selection = selected_option;

// Get mouse position in GUI coordinates
var mouse_gui_x = device_mouse_x_to_gui(0);
var mouse_gui_y = device_mouse_y_to_gui(0);

// Menu positioning (must match Draw GUI event)
var menu_y = display_get_gui_height()/2 + 50; // Move down from title
var spacing = 60; // Increase spacing for better visibility
var option_width = 300; // Approximate width for mouse hitbox
var option_height = 40; // Height for mouse hitbox

// Flag to prevent mouse hover interfering with keyboard navigation
var keyboard_used = false;

// Navigate menu with keyboard/gamepad
if (input_check_pressed("up")) {
    selected_option--;
    if (selected_option < 0) {
        selected_option = array_length(menu_options) - 1; // Wrap to bottom
    }
    keyboard_used = true;
}

if (input_check_pressed("down")) {
    selected_option++;
    if (selected_option >= array_length(menu_options)) {
        selected_option = 0; // Wrap to top
    }
    keyboard_used = true;
}

// Play navigation sound if selection changed via keyboard
if (keyboard_used && selected_option != prev_selection) {
    // Play sound effect if available
    if (audio_exists(snd_switch)) {
        playSFX(snd_switch, 1, 1, 1);
    }
}

// Check mouse hover over menu options (only if keyboard wasn't used this frame)
if (!keyboard_used) {
    for (var i = 0; i < array_length(menu_options); i++) {
        var y_pos = menu_y + (i * spacing);
        var x_pos = display_get_gui_width()/2;
        
        // Simple rectangle hitbox centered on text
        if (point_in_rectangle(mouse_gui_x, mouse_gui_y, 
            x_pos - option_width/2, y_pos - option_height/2,
            x_pos + option_width/2, y_pos + option_height/2)) {
            
            // Play sound if selection changed via mouse hover
            if (selected_option != i) {
                if (audio_exists(snd_switch)) {
                    playSFX(snd_switch, 1, 1, 1);
                }
            }
            
            selected_option = i; // Hover selects the option
            
            // Click to confirm
            if (mouse_check_button_pressed(mb_left)) {
                execute_selection();
            }
        }
    }
}

// Confirm selection with keyboard/gamepad
if (input_check_pressed("accept")) {
    execute_selection();
}

/// Execute the selected menu option
function execute_selection() {
    // Play selection sound
    if (audio_exists(snd_select)) {
        playSFX(snd_select, 1, 1, 1);
    }
    
    switch (selected_option) {
        case 0: // Restart from last savepoint
            global.isPaused = false;
            global.gameOver = false;
            room_restart();
            break;
            
        case 1: // Back to main menu
            global.isPaused = false;
            global.gameOver = false;
            room_goto(roomTitleScreen);
            break;
    }
}