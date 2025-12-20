/// obj_options Create Event

global.canPause = false;  // Set this FIRST before anything else

global.isPaused = true;

optionsMenuSelection = 0;

// Build options list - only include "Main Menu" if in a gameplay room
if (room != roomTitleScreen && room != roomCredits && room != RoomStart) {
    optionsList = [
        "Master Volume",
        "Music Volume",
        "SFX Volume",
        "Cursor Sensitivity",
        "Vibration",
        "Main Menu"
    ];
} else {
    optionsList = [
        "Master Volume",
        "Music Volume",
        "SFX Volume",
        "Cursor Sensitivity",
        "Vibration"
    ];
}

optionsMenuMaxSelection = array_length(optionsList) - 1;
txtScale = 1;
arrayOfObjToDeactivate = []; // Empty until TD objects exist

// UI styling
menu_x = room_width * 0.3;
menu_y = room_height * 0.2;
menu_width = room_width * 0.4;
menu_height = room_height * 0.6;
option_height = 60;
titleColor = make_color_rgb(125, 249, 255); // #7DF9FF
border_color = c_white;
text_color = c_white;
bg_alpha = 0.8;

// Main Menu confirmation variables
show_main_menu_confirmation = false;
main_menu_selection = "no";

// Initialize cursor sensitivity in saveData if it doesn't exist
if (!variable_struct_exists(global.saveData, "cursorSensitivity")) {
    global.saveData.cursorSensitivity = 0; // Default 0% (no modifier)
}

creation_frame = 0;